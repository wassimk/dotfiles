local function add_ruby_deps_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'RubyLSPShowDependencies', function(opts)
    local params = vim.lsp.util.make_text_document_params()
    local showAll = opts.args == 'all'

    client:request('rubyLsp/workspace/dependencies', params, function(error, result)
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
    local params = vim.lsp.util.make_position_params(vim.fn.bufwinid(bufnr), client.offset_encoding)

    client:request('rubyLsp/textDocument/showSyntaxTree', params, function(error, result)
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

      vim.cmd.vnew()
      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.keymap.set('n', 'q', '<cmd>quit<CR>', { buffer = buf, silent = true })
    end, bufnr)
  end, {
    nargs = '?',
    desc = 'Show Ruby Syntax Tree for current buffer',
  })
end

local function add_ruby_discover_tests_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'RubyLSPDiscoverTests', function()
    local params = { textDocument = vim.lsp.util.make_text_document_params() }

    client:request('rubyLsp/discoverTests', params, function(error, result)
      if error then
        print('Error discovering tests:')
        print(vim.inspect(error))
        return
      end

      local function extract_tests(tests, qf_list)
        for _, test in ipairs(tests) do
          table.insert(qf_list, {
            text = test.label,
            filename = vim.uri_to_fname(test.uri),
            lnum = test.range.start.line + 1,
            col = test.range.start.character + 1,
          })
          if test.children then
            extract_tests(test.children, qf_list)
          end
        end
      end

      local qf_list = {}
      extract_tests(result, qf_list)

      vim.fn.setqflist(qf_list)
      vim.cmd('copen')
    end, bufnr)
  end, {
    desc = 'Discover Ruby tests in current file',
  })
end

---@type vim.lsp.Config
return {
  init_options = {
    formatter = 'rubocop',
    linters = { 'rubocop' },
    enabledFeatureFlags = { fullTestDiscovery = true },
  },
  on_attach = function(client, bufnr)
    vim.lsp.log.set_level('trace')

    add_ruby_deps_command(client, bufnr)
    add_ruby_syntax_tree_command(client, bufnr)
    add_ruby_discover_tests_command(client, bufnr)

    -- conflicts with syntax tree inlay hints
    client.server_capabilities.inlayHintProvider = false
  end,
}
