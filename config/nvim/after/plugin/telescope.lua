--
-- telescope.nvim
-- https://github.com/nvim-telescope/telescope.nvim
--

if packer_plugins['telescope'] and packer_plugins['telescope'].loaded then
  require('telescope').load_extension('fzf')
  require('telescope').load_extension('ui-select')
end
