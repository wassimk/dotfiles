return {
  'rcarriga/nvim-notify',
  config = function()
    local wrapped_compact = require('notify.render.wrapped-compact')

    require('notify').setup({
      -- onedark darker's background. The default reads Normal's bg, which can
      -- briefly be missing and makes notify warn and fall back to black
      background_colour = '#1f2329',
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
