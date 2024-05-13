--
-- lsp
--

local M = {}

function M.setup()
  -- change border for lsp floats to single
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'single'
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end

  -- configure servers
  require('w.lsp.bash')
  require('w.lsp.css')
  require('w.lsp.emmet')
  require('w.lsp.html')
  require('w.lsp.javascript')
  require('w.lsp.json')
  require('w.lsp.lua')
  require('w.lsp.remark')
  require('w.lsp.ruby')
  require('w.lsp.rust')
  require('w.lsp.tailwind')
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

  vim.api.nvim_create_user_command('LspFormat', function()
    vim.lsp.buf.format()
  end, { desc = 'LSP: format with language servers' })

  vim.keymap.set('n', 'gld', '<cmd>Telescope lsp_definitions<cr>', opts('goto definitions'))
  vim.keymap.set('n', 'glt', '<cmd>Telescope lsp_type_definitions<cr>', opts('goto type definitions'))
  vim.keymap.set('n', 'glD', vim.lsp.buf.declaration, opts('goto declaration'))
  vim.keymap.set('n', 'gli', '<cmd>Telescope lsp_implementations<cr>', opts('goto implementations'))
  vim.keymap.set('n', 'glr', '<cmd>Telescope lsp_references<cr>', opts('goto references'))
  vim.keymap.set('n', 'glS', vim.lsp.buf.signature_help, opts('signature help'))
  vim.keymap.set('n', 'gls', '<cmd>Telescope lsp_document_symbols<cr>', opts('document symbols'))
  vim.keymap.set('n', 'glw', '<cmd>Telescope lsp_workspace_symbols<cr>', opts('workspace symbols'))
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts('rename'))

  vim.keymap.set('n', 'glh', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.in_layhint.is_enabled())
  end, opts('toggle inlay hints'))

  if client.name == 'rust_analyzer' then
    vim.keymap.set('n', '<F5>', '<cmd>RustDebuggables<cr>', { desc = 'RUST: debug menu' })
    vim.keymap.set({ 'n', 'v' }, 'gla', require('rust-tools').code_action_group.code_action_group, opts('code actions'))
    vim.keymap.set('n', 'K', require('rust-tools').hover_actions.hover_actions, opts('hover'))
  else
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('hover'))
    vim.keymap.set({ 'n', 'v' }, 'gla', vim.lsp.buf.code_action, opts('code actions'))
  end

  if client.name == 'tsserver' then
    client.server_capabilities.document_formatting = false
    client.server_capabilities.document_range_formatting = false
  end

  if client.server_capabilities.inlayHintProvider then
    if client.name ~= 'tsserver' then -- need newer typescript in my projects
      vim.lsp.inlay_hint.enable()
    end
  end
end

return M
