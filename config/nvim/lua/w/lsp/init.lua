--
-- lsp
--

local M = {}

function M.setup()
  -- configure servers
  require('w.lsp.ruby')

  vim.lsp.enable({
    'bash',
    'copilot',
    'css',
    'emmet',
    'eslint',
    -- 'go', -- configured by ray-x/go.nvim
    'html',
    -- 'javascript', -- configured by pmizio/typescript-tools.nvim
    'json',
    'lua_ls', -- supported by floke/lazydev.nvim
    'remark',
    -- 'rust', -- configured by by mrcjkb/rustaceanvim
    'tailwind',
    'vim',
    'yaml',
  })

  -- copilot inline completion
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('WamCopilotInlineCompletion', {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      if client.name ~= 'copilot' then
        return
      end

      -- Tab accept is handled by blink.cmp keymap chain (sidekick NES → inline completion → fallback)
      vim.lsp.inline_completion.enable(true, { bufnr = args.buf })
    end,
  })
end

function M.capabilities()
  return vim.lsp.protocol.make_client_capabilities()
end

function M.on_attach(client, bufnr)
  if bufnr == nil then
    return
  end

  local function opts(desc)
    return {
      buffer = 0,
      desc = 'LSP: ' .. desc,
    }
  end

  vim.keymap.set('n', 'gld', vim.lsp.buf.definition, opts('goto definitions'))
  vim.keymap.set('n', 'gly', vim.lsp.buf.type_definition, opts('goto type definitions'))
  vim.keymap.set('n', 'glt', '<cmd>execute "normal! <C-]>"<cr>', opts('tag jump'))
  vim.keymap.set('n', 'glD', vim.lsp.buf.declaration, opts('goto declaration'))
  vim.keymap.set('n', 'gli', vim.lsp.buf.implementation, opts('goto implementations'))
  vim.keymap.set('n', 'glr', vim.lsp.buf.references, opts('goto references'))
  vim.keymap.set('n', 'glS', vim.lsp.buf.signature_help, opts('signature help'))
  vim.keymap.set('n', 'gls', vim.lsp.buf.document_symbol, opts('document symbols'))
  vim.keymap.set('n', 'glw', vim.lsp.buf.workspace_symbol, opts('workspace symbols'))
  vim.keymap.set('n', 'gll', vim.lsp.codelens.run, opts('codelens run'))
  vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts('rename'))

  vim.keymap.set('n', 'glh', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
  end, opts('toggle inlay hints'))

  if client.name == 'rust-analyzer' then
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

  -- if vim.version.gt(vim.version(), { 0, 10, 0 }) then
  -- if client:supports_method('textDocument/completion') then
  --   vim.notify('completionProvider', vim.log.levels.INFO, { title = 'LSP' })
  --   vim.lsp.completion.enable(true, client.id, bufnr)
  -- end
  -- end

  if client:supports_method('textDocument/inlayHint') then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  local wamLspAutocmdsGrp = vim.api.nvim_create_augroup('WamLspAutocmds' .. bufnr, { clear = true })

  -- if client:supports_method('textDocument/documentHighlight') then
  --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  --     callback = function()
  --       vim.lsp.buf.document_highlight()
  --     end,
  --     buffer = bufnr,
  --     group = wamLspAutocmdsGrp,
  --   })
  --
  --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  --     callback = function()
  --       vim.lsp.buf.clear_references()
  --     end,
  --     buffer = bufnr,
  --     group = wamLspAutocmdsGrp,
  --   })
  -- end

  if client:supports_method('textDocument/codeLens') then
    vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
      callback = function()
        vim.lsp.codelens.enable(true, { bufnr = bufnr })
      end,
      group = wamLspAutocmdsGrp,
    })
  end
end

return M
