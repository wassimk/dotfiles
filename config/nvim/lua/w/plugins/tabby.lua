--
-- tabby.nvim
-- https://github.com/nanozuki/tabby.nvim
--

return {
  'nanozuki/tabby.nvim',
  config = function()
    local theme = {
      fill = 'TabLineFill',
      head = 'TabLine',
      current_tab = 'TabLineSel',
      tab = 'TabLine',
      win = 'TabLine',
      tail = 'TabLine',
    }

    require('tabby').setup({
      preset = 'tab_only',
      line = function(line)
        return {
          {
            { '   ', hl = theme.head },
            line.sep('', theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep('', hl, theme.fill),
              '', -- current tab
              '', -- tab number
              tab.name(),
              tab.close_btn('󰅖'),
              line.sep('', hl, theme.fill),
              hl = hl,
              margin = ' ',
            }
          end),
          line.spacer(),
          hl = theme.fill,
        }
      end,
    })
  end,
}
