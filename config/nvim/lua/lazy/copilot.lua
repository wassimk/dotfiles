--
-- copilot.lua
-- https://github.com/zbirenbaum/copilot.lua
--

local M = {}

function M.setup()
  require('copilot').setup({
    suggestion = {
      auto_trigger = true,
      keymap = {
        accept = '<Tab>',
      },
    },
    filetypes = {
      ['dap-repl'] = false,
      dapui_breakpoints = false,
      dapui_console = false,
      dapui_scopes = false,
      dapui_stacks = false,
      dapui_watches = false,
    },
    copilot_node_command = os.getenv('HOME') .. '/.asdf/installs/nodejs/18.13.0/bin/node',
  })
end

return M
