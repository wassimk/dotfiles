--
-- ruby language servers
--

local utils = require('w.utils')
local lspconfig = require('lspconfig')
local capabilities = require('w.lsp').capabilities()
local on_attach = require('w.lsp').on_attach

-- solargraph
if utils.installed_via_bundler('solargraph') then
  lspconfig.solargraph.setup({
    cmd = { 'bundle', 'exec', 'solargraph', 'stdio' },
    init_options = {
      formatting = false,
    },
    settings = {
      solargraph = {
        diagnostics = not utils.rubocop_supports_lsp(),
        logLevel = 'debug',
      },
    },
    commands = {
      SolargraphDocumentGems = {
        function()
          vim.lsp.buf_notify(0, '$/solargraph/documentGems')
        end,
        description = 'Build YARD documentation for installed gems',
      },
      SolargraphDocumentGemsWithRebuild = {
        function()
          vim.lsp.buf_notify(0, '$/solargraph/documentGems', { rebuild = true })
        end,
        description = 'Rebuild YARD documentation for installed gems',
      },
      SolargraphCheckGemVersion = {
        function()
          vim.lsp.buf_notify(0, '$/solargraph/checkGemVersion', { verbose = true })
        end,
        description = 'Check if a newer version of the gem is available',
      },
      SolargraphRestartServer = {
        function()
          vim.lsp.buf_notify(0, '$/solargraph/restartServer')
        end,
        description = 'A notification sent from the server to the client requesting that the client shut down and restart the server',
      },
    },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- ruby-lsp
if not utils.installed_via_bundler('solargraph') then
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

  lspconfig.ruby_lsp.setup({
    init_options = {
      formatter = 'rubocop',
      linters = { 'rubocop' },
    },
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      on_attach(client)

      add_ruby_deps_command(client, bufnr)
      add_ruby_syntax_tree_command(client, bufnr)

      -- conflicts with syntax tree inlay hints
      client.server_capabilities.inlayHintProvider = false
    end,
  })
end

-- syntax_tree
if utils.installed_via_bundler('syntax_tree') then
  lspconfig.syntax_tree.setup({
    cmd = { 'bundle', 'exec', 'stree', 'lsp' },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end

-- rubocop
if
  not utils.ruby_lsp_setup()
  and utils.installed_via_bundler('rubocop')
  and utils.config_exists('.rubocop.yml')
  and utils.rubocop_supports_lsp()
then
  lspconfig.rubocop.setup({
    cmd = { 'bundle', 'exec', 'rubocop', '--lsp' },
    capabilities = capabilities,
    on_attach = on_attach,
  })
end
