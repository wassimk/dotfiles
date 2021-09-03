----
-- lsp / completion
----
local custom_lsp_attach = function(client)
  -- See https://neovim.io/doc/user/lsp.html
  vim.api.nvim_buf_set_keymap(
    0, "n", "<Leader>ld", "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>",
    { noremap = true }
  )
  vim.api.nvim_buf_set_keymap(
    0, "n", "<Leader>cd", "<cmd>lua require('lspsaga.diagnostic').show_cursor_diagnostics()<CR>",
    { noremap = true }
  )
  vim.api.nvim_buf_set_keymap(
    0, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true }
  )
  vim.api.nvim_buf_set_keymap(
    0, "n", "gs", "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>",
    { noremap = true }
  )

  vim.api.nvim_buf_set_keymap(
    0, "n", "gr", "<cmd>lua require('lspsaga.rename').rename()<CR>", { noremap = true }
  )
  vim.api.nvim_buf_set_keymap(
    0, "n", "<Leader>ca", "<cmd>lua require('lspsaga.codeaction').code_action()<CR>",
    { noremap = true }
  )
  vim.api.nvim_buf_set_keymap(
    0, "v", "<Leader>ca", ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>",
    { noremap = true }
  )

  vim.api.nvim_buf_set_keymap(
    0, "n", "K", "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", { noremap = true }
  )

  vim.api.nvim_buf_set_keymap(
    0, "n", "[e", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>",
    { noremap = true }
  )
  vim.api.nvim_buf_set_keymap(
    0, "n", "]e", "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>",
    { noremap = true }
  )

  require("completion").on_attach()
end

-- configuration toggles
require"toggle_lsp_diagnostics".init({ start_on = true, virtual_text = false, underline = false })

-- ruby / solargraph
require("lspconfig").solargraph.setup({ on_attach = custom_lsp_attach })

-- javascript / typescript
-- require('lspconfig').tsserver.setup({on_attach = custom_lsp_attach})

----
-- lua
----

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
else
  print("Unsupported system for sumneko")
end

-- install lua language server via https://github.com/ninja-build/ninja/wiki/Pre-built-Ninja-packages
local sumneko_root_path = "/usr/local/lua-language-server" -- this is the git repo root
local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").sumneko_lua.setup {
  cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
  settings = {
    Lua = {
      runtime = { version = "Lua 5.4", path = runtime_path },
      diagnostics = { globals = { "vim", "hs" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) }
    }
  },
  on_attach = custom_lsp_attach
}

require("lspconfig").efm.setup {
  init_options = { documentFormatting = true },
  filetypes = { "lua" },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      lua = { { formatCommand = "lua-format -i --config=\"$HOME\"/.lua-format", formatStdin = true } }
    }
  }
}

vim.cmd("autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 100)")
