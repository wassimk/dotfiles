--
-- vim-abolish
-- https://github.com/tpope/vim-abolish
--

local has_abolish = pcall(require, 'vim-abolish')

if not has_abolish then
  return
end

vim.cmd([[
  Abolish precense presence
  Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}  {despe,sepa}rat{}
  Abolish nofity notify
]])
