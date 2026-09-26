--
-- vim-herdr-navigation
-- https://github.com/paulbkim-dev/vim-herdr-navigation
--
-- Seamless <C-h/j/k/l> between neovim splits and herdr panes. The herdr side
-- is a herdr plugin (installed by install.sh) bound to the same keys in
-- ~/.config/herdr/config.toml. The repo is not a regular neovim plugin, so
-- source its editor file by hand.
--

return {
  'paulbkim-dev/vim-herdr-navigation',
  cond = vim.env.HERDR_ENV == '1',
  lazy = false,
  config = function(plugin)
    dofile(plugin.dir .. '/editor/nvim.lua')
  end,
}
