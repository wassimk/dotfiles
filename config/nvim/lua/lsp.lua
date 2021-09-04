----
-- lsp
----
-- configuration toggles this my new completion engine it has stuff like spellbind
require("toggle_lsp_diagnostics").init({ start_on = true, virtual_text = false, underline = false })

-- ruby / solargraph
require("lspconfig").solargraph.setup({})

-- vimscript
require("lspconfig").vimls.setup({})

-- javascript / typescript
require("lspconfig").tsserver.setup({})

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
  }
}

----
-- formatter
----

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
