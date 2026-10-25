--
-- mason.nvim, mason-tool-installer.nvim
-- https://github.com/williamboman/mason.nvim
-- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim

local tools = {
  'bash-language-server', -- lsp
  'codelldb', -- used by nvim-dap
  'codespell', -- used by nvim-lint
  'commitlint', -- used by nvim-lint
  'copilot-language-server',
  'css-lsp',
  'emmet-language-server',
  'eslint-lsp',
  'gopls', -- used by ray-x/go.nvim
  'herb-language-server',
  'html-lsp',
  'json-lsp',
  'lua-language-server',
  'luacheck', -- used by nvim-lint
  'prettierd', -- used by conform.nvim
  'selene', -- used by nvim-lint
  'shellcheck', -- used by bash-language-server
  'stimulus-language-server',
  'stylua', -- used by conform.nvim
  'tailwindcss-language-server',
  'tree-sitter-cli', -- used by nvim-treesitter (main branch) to compile parsers
  'typescript-language-server', -- used by typescript-tools.nvim
  'vim-language-server',
  'yaml-language-server',
}

local start_delay = 10000

-- 'pkg:npm/%40github/copilot-language-server@1.556.0' -> '@github/copilot-language-server'
local function npm_name(source_id)
  local purl = source_id:match('^pkg:npm/(.+)$')
  if not purl then
    return nil
  end
  return (purl:gsub('%%40', '@'):gsub('(.)@[^@/]+$', '%1'))
end

-- highest stable version in `npm view <name> versions --json` output
local function newest_stable(json)
  local ok, versions = pcall(vim.json.decode, json)
  if not ok then
    return nil
  end
  versions = type(versions) == 'table' and versions or { versions }

  local newest
  for _, v in ipairs(versions) do
    local parsed = vim.version.parse(v, { strict = true })
    if parsed and not parsed.prerelease and (not newest or vim.version.gt(parsed, newest)) then
      newest = parsed
    end
  end
  return newest and tostring(newest)
end

-- mason package name -> newest version the npm proxy serves
local proxy_versions = {}

local function proxy_version(source_id, on_done)
  local name = npm_name(source_id)
  if not name then
    return nil
  end
  local cmd = { 'npm', 'view', name, 'versions', '--json' }
  local function parse(result)
    return result.code == 0 and newest_stable(result.stdout) or nil
  end
  if on_done then
    vim.system(cmd, { text = true }, function(result)
      on_done(parse(result))
    end)
  else
    local ok, result = pcall(function()
      return vim.system(cmd, { text = true }):wait(10000)
    end)
    return ok and parse(result) or nil
  end
end

-- callbacks waiting on the lookup, or nil once it has finished
local proxy_waiting = {}

-- look up proxy versions for configured and installed packages once, so
-- update checks don't block
local function load_proxy_versions(callback)
  if not proxy_waiting then
    return callback()
  end
  table.insert(proxy_waiting, callback)
  if #proxy_waiting > 1 then
    return
  end

  local registry = require('mason-registry')

  registry.refresh(function()
    local pending = 1
    local function done()
      pending = pending - 1
      if pending == 0 then
        vim.schedule(function()
          local waiting = proxy_waiting
          proxy_waiting = nil
          for _, cb in ipairs(waiting) do
            cb()
          end
        end)
      end
    end

    local names = {}
    for _, tool in ipairs(tools) do
      names[tool] = true
    end
    for _, pkg in ipairs(registry.get_installed_packages()) do
      names[pkg.name] = true
    end

    for name in pairs(names) do
      local ok, pkg = pcall(registry.get_package, name)
      if ok and npm_name(pkg.spec.source.id) then
        pending = pending + 1
        proxy_version(pkg.spec.source.id, function(version)
          proxy_versions[name] = version
          done()
        end)
      end
    end

    done()
  end)
end

-- The npm proxy hides releases newer than its minimum age, but mason always
-- asks for the newest version in its registry, so npm packages fail to
-- install. Make mason's idea of "latest" the newest stable version the proxy
-- lists instead, which covers the :Mason UI, :MasonInstall and
-- mason-tool-installer alike. The proxy's `latest` tag can't be used because
-- it may point at a prerelease (yaml-language-server nightlies).
local function follow_npm_proxy()
  local Package = require('mason-core.package')

  local get_latest_version = Package.get_latest_version
  function Package:get_latest_version()
    return proxy_versions[self.name] or get_latest_version(self)
  end

  local install = Package.install
  function Package:install(opts, callback)
    opts = opts or {}
    if not opts.version then
      proxy_versions[self.name] = proxy_versions[self.name] or proxy_version(self.spec.source.id)
      opts.version = proxy_versions[self.name]
    end
    return install(self, opts, callback)
  end

  -- the :Mason UI marks packages outdated as it opens, so have proxy versions
  -- ready first rather than paying for the lookup on every startup
  local ui = require('mason.ui')
  local open = ui.open
  function ui.open(...)
    local args = { ... }
    load_proxy_versions(function()
      open(unpack(args))
    end)
  end
end

-- Python packages (codespell) live in a venv linked to the exact python that
-- built it. Homebrew deletes old pythons once no formula needs them, which
-- breaks the venv, and mason only rebuilds it on a new package release.
-- Reinstall any package whose venv python is gone.
local function repair_python_venvs()
  local registry = require('mason-registry')

  for _, pkg in ipairs(registry.get_installed_packages()) do
    local cfg = vim.fs.joinpath(pkg:get_install_path(), 'venv', 'pyvenv.cfg')
    local ok, lines = pcall(vim.fn.readfile, cfg)
    if ok then
      local home
      for _, line in ipairs(lines) do
        home = home or line:match('^home%s*=%s*(.-)%s*$')
      end
      if home and not vim.uv.fs_stat(home) and not pkg:is_installing() then
        vim.notify('mason: rebuilding ' .. pkg.name .. ', its python was removed', vim.log.levels.INFO)
        pkg:install({ force = true })
      end
    end
  end
end

return {
  'williamboman/mason.nvim',
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    require('mason').setup()
    follow_npm_proxy()

    -- mason auto-update
    local installer = require('mason-tool-installer')
    installer.setup({
      ensure_installed = tools,
      auto_update = true,
      run_on_start = false, -- started below once proxy versions are loaded
      debounce_hours = 5,
    })

    vim.defer_fn(function()
      repair_python_venvs()
      load_proxy_versions(function()
        installer.check_install(false)
      end)
    end, start_delay)
  end,
}
