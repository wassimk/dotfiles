--
-- lazydev, nvim-lspconfig, typescript-tools.nvim
-- https://github.com/j-hui/fidget.nvim
-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/folke/lazydev.nvim
-- https://github.com/pmizio/typescript-tools.nvim
--

local function fidget_format_message(msg)
  local lsp_name = msg.lsp_client.config.name
  local message = msg.message

  if not message then
    message = msg.done and 'Completed' or 'In progress...'
  end

  if msg.percentage ~= nil and lsp_name ~= 'ruby_lsp' then
    message = string.format('%s (%.0f%%)', message, msg.percentage)
  end
  return message
end

return {
  {
    'j-hui/fidget.nvim',
    opts = {
      progress = {
        display = {
          format_message = fidget_format_message,
        },
      },
    },
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    },
  },
  {
    'pmizio/typescript-tools.nvim',
    ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    opts = {
      debug = false,
      settings = {
        expose_as_code_action = {
          -- 'add_missing_imports',
          -- 'organize_imports',
          -- 'remove_unused',
          -- 'remove_unused_imports',
        },
      },
    },
    dependencies = {
      'neovim/nvim-lspconfig',
      -- { 'antosha417/nvim-lsp-file-operations', config = true },
    },
  },
  {
    'neovim/nvim-lspconfig', -- provides base cmd/filetypes/root_markers for all servers
  },
}
