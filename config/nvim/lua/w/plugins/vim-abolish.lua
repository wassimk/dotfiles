--
-- vim-abolish
-- https://github.com/tpope/vim-abolish

return {
  'tpope/vim-abolish',
  config = function()
    vim.cmd([[
      Abolish precense presence
      Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}  {despe,sepa}rat{}
      Abolish nofity notify
      Abolish beacuse because
      Abolish teste test
      Abolish acknowledgement acknowledgment
    ]])
  end,
}
