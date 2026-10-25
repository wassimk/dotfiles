return {
  'rcarriga/nvim-notify',
  config = function()
    local wrapped_compact = require('notify.render.wrapped-compact')

    require('notify').setup({
      -- wrapped-compact crashes on empty messages (indexes a nil first line),
      -- which snacks' notifier healthcheck sends as a probe
      render = function(bufnr, notif, highlights, config)
        if vim.trim(table.concat(notif.message, '')) == '' then
          notif.message = { ' ' }
        end
        return wrapped_compact(bufnr, notif, highlights, config)
      end,
    })
    vim.notify = require('notify')
  end,
}
