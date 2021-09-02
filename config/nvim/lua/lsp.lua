----
-- lsp / completion
----

local custom_lsp_attach = function(client)
  -- See https://neovim.io/doc/user/lsp.html
  vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>ld', "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>", {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>cd', "<cmd>lua require('lspsaga.diagnostic').show_cursor_diagnostics()<CR>", {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'gs', "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", {noremap = true})

  vim.api.nvim_buf_set_keymap(0, 'n', 'gr', "<cmd>lua require('lspsaga.rename').rename()<CR>", {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>ca', "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", {noremap = true })
  vim.api.nvim_buf_set_keymap(0, 'v', '<Leader>ca', ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>", {noremap = true })

  vim.api.nvim_buf_set_keymap(0, 'n', 'K', "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", {noremap = true})

  vim.api.nvim_buf_set_keymap(0, 'n', '[e', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>", {noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n', ']e', "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>", {noremap = true})
  require('completion').on_attach()
end

-- configuration toggles
require'toggle_lsp_diagnostics'.init({ start_on = true, virtual_text = false, underline = false })

-- ruby / solargraph
require('lspconfig').solargraph.setup({on_attach = custom_lsp_attach})

-- javascript / typescript
-- require('lspconfig').tsserver.setup({on_attach = custom_lsp_attach})
