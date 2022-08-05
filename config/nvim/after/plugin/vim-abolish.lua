--
-- vim-abolish
-- https://github.com/tpope/vim-abolish
--

if packer_plugins['vim-abolish'] and packer_plugins['vim-abolish'].loaded then
  vim.cmd([[
    Abolish precense presence
    Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}  {despe,sepa}rat{}
    Abolish nofity notify
  ]])
end
