--
-- lsp
--

local M = {}

function M.setup()
  require('w.lsp.bash')
  require('w.lsp.css')
  require('w.lsp.html')
  require('w.lsp.javascript')
  require('w.lsp.json')
  require('w.lsp.lua')
  require('w.lsp.ruby')
  require('w.lsp.rust')
  require('w.lsp.vim')
  require('w.lsp.yaml')
end

function M.capabilities()
  return require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

function M.on_attach(client)
  local opts = { buffer = 0, silent = true }

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', '<cmd>TroubleToggle lsp_definitions<cr>', opts)
  vim.keymap.set('n', 'gi', '<cmd>TroubleToggle lsp_implementations<cr>', opts)
  vim.keymap.set('n', 'gr', '<cmd>TroubleToggle lsp_references<cr>', opts)
  vim.keymap.set('n', 'gS', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', 'gd$', vim.lsp.buf.document_symbol, opts)
  vim.keymap.set('n', 'gw$', vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>D', 'TroubleToggle lsp_type_definitions<cr>', opts)
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)

  if client.name == 'rust_analyzer' then
    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', require('rust-tools').code_action_group.code_action_group, opts)
    vim.keymap.set('n', 'K', require('rust-tools').hover_actions.hover_actions, opts)
  else
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  end

  if client.name == 'tsserver' then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end
end

return M
