--
-- nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig
--

return {
  'neovim/nvim-lspconfig',
  event = { 'BufNewFile', 'BufReadPre', 'CmdlineEnter' },
  dependencies = {
    { 'folke/neodev.nvim', version = '*' },
    'pmizio/typescript-tools.nvim',
    'simrat39/rust-tools.nvim',
    'williamboman/mason-lspconfig.nvim',
    -- { 'antosha417/nvim-lsp-file-operations', config = true },
    {
      'j-hui/fidget.nvim',
      config = true,
    },
  },
}
