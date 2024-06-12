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
  require('w.lsp.go')
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

function M.on_attach(client, bufnr)
  local function opts(desc)
    return {
      buffer = 0,
      desc = 'LSP: ' .. desc,
    }
  end

  vim.api.nvim_create_user_command('LspFormat', function()
    vim.lsp.buf.format()
  end, { desc = 'LSP: format with language servers' })

  vim.keymap.set('n', 'gld', vim.lsp.buf.definition, opts('goto definitions'))
  vim.keymap.set('n', 'gly', vim.lsp.buf.type_definition, opts('goto type definitions'))
  vim.keymap.set('n', 'glt', '<cmd>execute "normal! <C-]>"<cr>', opts('tag jump'))
  vim.keymap.set('n', 'glD', vim.lsp.buf.declaration, opts('goto declaration'))
  vim.keymap.set('n', 'gli', vim.lsp.buf.implementation, opts('goto implementations'))
  vim.keymap.set('n', 'glr', vim.lsp.buf.references, opts('goto references'))
  vim.keymap.set('n', 'glS', vim.lsp.buf.signature_help, opts('signature help'))
  vim.keymap.set('n', 'gls', vim.lsp.buf.document_symbol, opts('document symbols'))
  vim.keymap.set('n', 'glw', vim.lsp.buf.workspace_symbol, opts('workspace symbols'))
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts('rename'))

  vim.keymap.set('n', 'glh', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, opts('toggle inlay hints'))

  if client.name == 'rust-analyzer' then
    vim.print('RUST: using rust_analyzer')
    vim.keymap.set('n', '<F5>', function()
      vim.cmd.RustLsp('debug')
    end, { desc = 'RUST: debug menu' })
    vim.keymap.set({ 'n', 'v' }, 'gla', function()
      vim.cmd.RustLsp('codeAction')
    end, opts('code actions'))
    vim.keymap.set('n', 'K', function()
      vim.cmd.RustLsp({ 'hover', 'actions' })
    end, opts('hover'))
  else
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('hover'))
    vim.keymap.set({ 'n', 'v' }, 'gla', vim.lsp.buf.code_action, opts('code actions'))
  end

  if vim.version.gt(vim.version(), { 0, 10, 0 }) then
    if vim.version.gte(vim.version(), { 0, 11, 0 }) then
      vim.notify(
        'nvim version is 0.11.0+, remove completion.enable version check',
        vim.log.levels.INFO,
        { title = 'LSP' }
      )
    end

    vim.lsp.completion.enable(true, client.id, bufnr)
  end

  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable()
  end

  if client.server_capabilities.codeLensProvider then
    local bufnr = vim.api.nvim_get_current_buf()
    local wamGrp = vim.api.nvim_create_augroup('WamLspAutocmds', {})
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      callback = function()
        vim.lsp.codelens.refresh({ bufnr = bufnr })
      end,
      group = wamGrp,
    })
  end
end

return M
