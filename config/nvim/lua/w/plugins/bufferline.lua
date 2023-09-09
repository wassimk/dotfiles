--
-- bufferline.nvim
-- https://github.com/akinsho/bufferline.nvim
--

return {
  'akinsho/bufferline.nvim',
  event = 'BufRead',
  version = '*',
  opts = {
    options = {
      separator_style = 'slant',
      mode = 'tabs',
      show_buffer_close_icons = false,
      show_close_icon = false,
      always_show_bufferline = false,
      enforce_regular_tabs = false,
      offsets = {
        {
          filetype = 'NvimTree',
          text = nil,
        },
      },
      custom_filter = function(buf_number, _)
        -- don't switch buffer names for these tools
        if
          vim.bo[buf_number].filetype ~= 'NvimTree'
          and vim.bo[buf_number].filetype ~= 'TelescopePrompt'
          and vim.bo[buf_number].filetype ~= 'terminal'
          and vim.bo[buf_number].filetype ~= 'packer'
        then
          return true
        else
          return false
        end
      end,
    },
  },
}
