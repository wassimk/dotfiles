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
  local function opts(desc)
    return {
      buffer = 0,
      desc = 'LSP: ' .. desc,
    }
  end

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts('goto declaration'))
  vim.keymap.set('n', 'gd', '<cmd>Trouble lsp_definitions<cr>', opts('goto definitions'))
  vim.keymap.set('n', 'gi', '<cmd>Trouble lsp_implementations<cr>', opts('goto implementations'))
  vim.keymap.set('n', 'gr', '<cmd>Trouble lsp_references<cr>', opts('goto references'))
  vim.keymap.set('n', 'gS', vim.lsp.buf.signature_help, opts('signature help'))
  vim.keymap.set('n', 'gd$', vim.lsp.buf.document_symbol, opts('document symbols'))
  vim.keymap.set('n', 'gw$', vim.lsp.buf.workspace_symbol, opts('workspace symbols'))
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts('rename'))
  vim.keymap.set('n', '<leader>D', 'Trouble lsp_type_definitions<cr>', opts('goto type definitions'))
  vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts('format'))

  if client.name == 'rust_analyzer' then
    vim.keymap.set(
      { 'n', 'v' },
      '<Leader>ca',
      require('rust-tools').code_action_group.code_action_group,
      opts('code actions')
    )
    vim.keymap.set('n', 'K', require('rust-tools').hover_actions.hover_actions, opts('hover'))
  else
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('hover'))
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts('code actions'))
  end

  if client.name == 'tsserver' then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end
end

return M
