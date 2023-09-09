--
-- nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig
--

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'folke/neodev.nvim', version = '*' },
    'jose-elias-alvarez/typescript.nvim',
    'simrat39/rust-tools.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
}