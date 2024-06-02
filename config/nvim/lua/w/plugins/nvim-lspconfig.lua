--
-- nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig
--

local function fidget_format_message(msg)
  local lsp_name = msg.lsp_client.config.name
  local message = msg.message

  if not message then
    message = msg.done and 'Completed' or 'In progress...'
  end

  if msg.percentage ~= nil and not lsp_name == 'ruby_lsp' then
    message = string.format('%s (%.0f%%)', message, msg.percentage)
  end
  return message
end

return {
  'neovim/nvim-lspconfig',
  event = { 'BufNewFile', 'BufReadPre', 'CmdlineEnter' },
  dependencies = {
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      config = true,
    },
    'pmizio/typescript-tools.nvim',
    'simrat39/rust-tools.nvim',
    'williamboman/mason-lspconfig.nvim',
    -- { 'antosha417/nvim-lsp-file-operations', config = true },
    {
      'j-hui/fidget.nvim',
      config = {
        progress = {
          display = {

            format_message = fidget_format_message,
          },
        },
      },
    },
  },
}
