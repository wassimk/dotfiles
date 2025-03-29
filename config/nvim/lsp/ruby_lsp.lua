--
-- Ruby LSP Language Server
--

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
      vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':quit<CR>', { noremap = true, silent = true })
    end, bufnr)
  end, {
    nargs = '?',
    desc = 'Show Ruby Syntax Tree for current buffer',
  })
end

local default_config = require('lspconfig.configs.ruby_lsp').default_config
default_config.root_dir = nil

local custom_config = {
  init_options = {
    formatter = 'rubocop',
    linters = { 'rubocop' },
  },
  capabilities = require('w.lsp').capabilities(),
  on_attach = function(client, bufnr)
    require('w.lsp').on_attach(client)

    add_ruby_deps_command(client, bufnr)
    add_ruby_syntax_tree_command(client, bufnr)

    -- conflicts with syntax tree inlay hints
    client.server_capabilities.inlayHintProvider = false
  end,
}

return vim.tbl_deep_extend('force', default_config, custom_config)
