return {
  'rcarriga/nvim-notify',
  config = function()
    require('notify').setup({ render = 'compact' })
    vim.notify = require('notify')
  end,
}
