require('bufferline').setup {
  options = {
    mode = 'tabs',
    show_buffer_close_icons = true,
    show_close_icon = false,
    always_show_bufferline = false,
    separator_style = 'slant',
    enforce_regular_tabs = false,
    offsets = {
      {
        filetype = 'NvimTree',
        text = function()
          return vim.fn.getcwd()
        end,
        highlight = 'Directory',
        text_align = 'left'
      }
    }
  }
}
