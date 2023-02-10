--
-- indent-blankline.nvim
-- https://github.com/lukas-reineke/indent-blankline.nvim
--

local has_indent_blankline, indent_blankline = pcall(require, 'luasnip')

if has_indent_blankline then
  indent_blankline.setup({
    show_current_context = false,
  })
end
