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

-- The npm proxy hides releases newer than its minimum age, but mason always
-- asks for the newest version in its registry, so fast-moving npm packages
-- fail to install. Pin each npm tool to the newest stable version the proxy
-- lists instead. Its `latest` tag can't be used because it may point at a
-- prerelease (yaml-language-server nightlies).
local function pin_npm_versions(callback)
  local registry = require('mason-registry')

  registry.refresh(function()
    local pending, entries = 1, {}

    local function done()
      pending = pending - 1
      if pending == 0 then
        vim.schedule(function()
          callback(entries)
        end)
      end
    end

    for i, tool in ipairs(tools) do
      entries[i] = tool
      local ok, pkg = pcall(registry.get_package, tool)
      local name = ok and npm_name(pkg.spec.source.id)

      if name then
        pending = pending + 1
        vim.system({ 'npm', 'view', name, 'versions', '--json' }, { text = true }, function(result)
          local version = result.code == 0 and newest_stable(result.stdout)
          if version then
            entries[i] = { tool, version = version }
          else
            -- proxy unreachable, keep what is installed rather than fail
            entries[i] = { tool, auto_update = false }
          end
          done()
        end)
      end
    end

    done()
  end)
end

return {
  'williamboman/mason.nvim',
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    require('mason').setup()

    -- mason auto-update
    local installer = require('mason-tool-installer')
    installer.setup({
      ensure_installed = tools,
      auto_update = true,
      run_on_start = false, -- started below once npm versions are pinned
      debounce_hours = 5,
    })

    vim.defer_fn(function()
      pin_npm_versions(function(entries)
        installer.setup({ ensure_installed = entries })
        installer.check_install(false)
      end)
    end, start_delay)
  end,
}
