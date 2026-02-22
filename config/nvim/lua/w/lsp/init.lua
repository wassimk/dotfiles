--
-- lsp
--

local M = {}

function M.setup()
  -- global LspAttach: keymaps, inlay hints, codelens for all servers
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('WamLspAttach', {}),
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
      local bufnr = args.buf

      -- skip copilot (handled separately below)
      if client.name == 'copilot' then
        return
      end

      local function opts(desc)
        return {
          buffer = bufnr,
          desc = desc,
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

      -- Rust Language Server
      if client.name == 'rust-analyzer' then
        vim.keymap.set('n', '<Leader>dS', function()
          vim.cmd.RustLsp('debug')
        end, { desc = 'rust debug menu' })
        vim.keymap.set({ 'n', 'v' }, 'gla', function()
          vim.cmd.RustLsp('codeAction')
        end, opts('code actions'))
        vim.keymap.set('n', 'K', function()
          vim.cmd.RustLsp({ 'hover', 'actions' })
        end, opts('hover'))
      else
        -- default keymaps for other servers
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('hover'))
        vim.keymap.set({ 'n', 'v' }, 'gla', vim.lsp.buf.code_action, opts('code actions'))
      end

      -- inlay hints
      vim.keymap.set('n', 'glh', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, opts('toggle inlay hints'))

      if client:supports_method('textDocument/inlayHint') then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end

      -- codelens
      if client:supports_method('textDocument/codeLens') then
        vim.lsp.codelens.enable(true, { bufnr = bufnr })
      end
    end,
  })

  -- configure servers
  require('w.lsp.ruby')

  vim.lsp.enable({
    'bashls',
    'copilot',
    'cssls',
    'emmet_language_server',
    'eslint',
    -- 'gopls', -- configured by ray-x/go.nvim
    'html',
    -- 'ts_ls', -- configured by pmizio/typescript-tools.nvim
    'jsonls',
    'lua_ls', -- supported by folke/lazydev.nvim
    -- 'rust_analyzer', -- configured by mrcjkb/rustaceanvim
    'tailwindcss',
    'vimls',
    'yamlls',
  })

  -- copilot inline completion (separate from shared LspAttach since it only applies to copilot)
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

return M
