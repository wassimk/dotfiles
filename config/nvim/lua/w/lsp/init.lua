--
-- lsp
--

local M = {}

local function add_ruby_deps_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'RubyLSPShowDependencies', function(opts)
    local params = vim.lsp.util.make_text_document_params()
    local showAll = opts.args == 'all'

    client.request('rubyLsp/workspace/dependencies', params, function(error, result)
      if error then
        print('Error showing Ruby dependencies:')
        print(vim.inspect(error))
        return
      end

      local qf_list = {}
      for _, item in ipairs(result) do
        if showAll or item.dependency then
          table.insert(qf_list, {
            text = string.format('%s (%s) - %s', item.name, item.version, item.dependency),
            filename = item.path,
          })
        end
      end

      vim.fn.setqflist(qf_list)
      vim.cmd('copen')
    end, bufnr)
  end, {
    nargs = '?',
    desc = 'Show Ruby dependencies for current workspace',
    complete = function()
      return { 'all' }
    end,
  })
end

local function add_ruby_syntax_tree_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'RubyLSPShowSyntaxTree', function()
    local params = vim.lsp.util.make_position_params()

    client.request('rubyLsp/textDocument/showSyntaxTree', params, function(error, result)
      if error then
        print('Error showing Syntax Tree for buffer: ')
        print(vim.inspect(error))
        return
      end

      local ast = result.ast
      local lines = {}
      for line in ast:gmatch('[^\r\n]+') do
        table.insert(lines, line)
      end

      vim.api.nvim_command('vnew')
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end, bufnr)
  end, {
    nargs = '?',
    desc = 'Show Ruby Syntax Tree for current buffer',
  })
end

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
    if client.name == 'tsserver' then -- need newer typescript in my projects
      vim.lsp.inlay_hint.disable()
    end
  end

  if client.name == 'ruby_lsp' then
    add_ruby_deps_command(client, bufnr)
    add_ruby_syntax_tree_command(client, bufnr)
  end
end

return M
