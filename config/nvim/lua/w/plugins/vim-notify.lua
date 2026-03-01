return {
  'rcarriga/nvim-notify',
  config = function()
    require('notify').setup({ render = 'wrapped-compact' })
    vim.notify = require('notify')
  end,
}
