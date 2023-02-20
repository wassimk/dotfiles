--
-- ruby filetype
--

-- format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(event)
    if vim.endswith(event.file, '.html.erb') then
      return
    end

    vim.lsp.buf.format()
  end,
  group = vim.api.nvim_create_augroup('WamAutocmdsRubyFormatting', {}),
})

----
-- language servers
----
local utils = require('w.utils')

local root_files = {
  'Gemfile',
  '.git',
  '.solargraph.yml',
  '.rubocop.yml',
  '.streerc',
}

-- solargraph
if utils.installed_via_bundler('solargraph') then
  vim.lsp.start({
    name = 'solargraph',
    cmd = { 'bundle', 'exec', 'solargraph', 'stdio' },
    root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
    filetypes = { 'ruby' },
    init_options = {
      formatting = false,
    },
    settings = {
      solargraph = {
        diagnostics = true,
      },
    },
    capabilities = require('w.lsp').capabilities(),
  })
end

-- ruby-lsp
if utils.installed_via_bundler('ruby%-lsp') then
  local enabled_features = {
    'documentHighlights',
    'documentSymbols',
    'foldingRanges',
    'selectionRanges',
    'semanticHighlighting',
    -- 'formatting',
    'diagnostics',
    'codeActions',
  }

  vim.lsp.start({
    name = 'ruby-lsp',
    cmd = { 'bundle', 'exec', 'ruby-lsp' },
    root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
    init_options = {
      enabledFeatures = enabled_features,
    },
    capabilities = require('w.lsp').capabilities(),
  })
end

-- syntax_tree
if utils.installed_via_bundler('syntax_tree') then
  vim.lsp.start({
    name = 'syntax-tree',
    cmd = { 'bundle', 'exec', 'stree', 'lsp' },
    root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
    filetypes = { 'ruby' },
    capabilities = require('w.lsp').capabilities(),
  })
end

-- debugging
local dap = require('dap')

dap.adapters.ruby = function(callback, config)
  local args = {
    'exec',
    'rdbg',
    '--open',
    '--nonstop',
    '--port',
    '${port}',
    '--command',
    '--',
  }

  vim.list_extend(args, config.command)
  vim.list_extend(args, config.script)

  if config.script_args then
    vim.list_extend(args, config.script_args)
  end

  callback({
    type = 'server',
    host = '127.0.0.1',
    port = '${port}',
    executable = {
      command = 'bundle',
      args = args,
    },
  })
end

dap.configurations.ruby = {
  {
    type = 'ruby',
    name = 'debug file',
    request = 'attach',
    localfs = true,
    command = { 'bundle', 'exec', 'ruby' },
    script = { '${relativeFile}' },
  },
  {
    type = 'ruby',
    name = 'debug file (prompt)',
    request = 'attach',
    localfs = true,
    command = { 'bundle', 'exec', 'ruby' },
    script = { '${relativeFile}' },
    script_args = function()
      local argument_string = vim.fn.input('Program arguments: ')
      return vim.fn.split(argument_string, ' ', true)
    end,
  },
  {
    type = 'ruby',
    name = 'debug test file',
    request = 'attach',
    localfs = true,
    command = { 'bundle', 'exec', 'ruby' },
    script = { 'bin/rails', 'test', '${relativeFile}' },
  },
  {
    type = 'ruby',
    name = 'debug test nearest',
    request = 'attach',
    localfs = true,
    command = { 'bundle', 'exec', 'ruby' },
    script = function()
      local line = vim.api.nvim_win_get_cursor(0)[1]

      return { 'bin/rails', 'test', '${relativeFile}:' .. line }
    end,
  },
  {
    type = 'ruby',
    name = 'debug spec file',
    request = 'attach',
    localfs = true,
    command = { 'bundle', 'exec', 'ruby' },
    script = { 'bin/rspec', '${relativeFile}' },
  },
  {
    type = 'ruby',
    name = 'debug spec nearest',
    request = 'attach',
    localfs = true,
    command = { 'bundle', 'exec', 'ruby' },
    script = function()
      local line = vim.api.nvim_win_get_cursor(0)[1]

      return { 'bin/rspec', '${relativeFile}:' .. line }
    end,
  },
}
