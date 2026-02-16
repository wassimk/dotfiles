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

-- debugging
local dap = require('dap')

dap.adapters.ruby = function(callback, config)
  local args = {
    'exec',
    'rdbg',
    '--open',
    -- '--nonstop',
    '--stop-at-load',
    '--port',
    '${port}',
    '--command',
    '--',
    'bundle',
    'exec',
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
    command = { 'ruby' },
    script = { '${relativeFile}' },
  },
  {
    type = 'ruby',
    name = 'debug file (prompt)',
    request = 'attach',
    localfs = true,
    command = { 'ruby' },
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
    command = { 'ruby', 'bin/rails', 'test' },
    script = { '${relativeFile}' },
  },
  {
    type = 'ruby',
    name = 'debug test nearest',
    request = 'attach',
    localfs = true,
    command = { 'ruby', 'bin/rails', 'test' },
    script = function()
      local line = vim.api.nvim_win_get_cursor(0)[1]

      return { '${relativeFile}:' .. line }
    end,
  },
  {
    type = 'ruby',
    name = 'debug spec file',
    request = 'attach',
    localfs = true,
    command = { 'ruby', 'bin/rspec' },
    script = { '${relativeFile}' },
  },
  {
    type = 'ruby',
    name = 'debug spec nearest',
    request = 'attach',
    localfs = true,
    command = { 'ruby', 'bin/rspec' },
    script = function()
      local line = vim.api.nvim_win_get_cursor(0)[1]

      return { '${relativeFile}:' .. line }
    end,
  },
}

-- Using universal-ctags for Ruby (ripper-tags doesn't work with Ruby 3.3+ Prism)
