--
-- ruby filetype
--

-- format on save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    vim.lsp.buf.format()
  end,
  group = vim.api.nvim_create_augroup('WamAutocmdsRubyFormatting', {}),
})

-- debugging
local dap = require('dap')

dap.adapters.ruby = function(callback, config)
  callback({
    type = 'server',
    host = '127.0.0.1',
    port = '${port}',
    executable = {
      command = 'bundle',
      args = {
        'exec',
        'rdbg',
        '-n',
        '--open',
        '--port',
        '${port}',
        '-c',
        '--',
        'bundle',
        'exec',
        config.command,
        config.script,
      },
    },
  })
end

dap.configurations.ruby = {
  {
    type = 'ruby',
    name = 'debug current file',
    request = 'attach',
    localfs = true,
    command = 'ruby',
    script = '${file}',
  },
  {
    type = 'ruby',
    name = 'run current spec file',
    request = 'attach',
    localfs = true,
    command = 'rspec',
    script = '${file}',
  },
  {
    type = 'ruby',
    name = 'run current test file',
    request = 'attach',
    localfs = true,
    command = 'rails test',
    script = '${file}',
  },
}
