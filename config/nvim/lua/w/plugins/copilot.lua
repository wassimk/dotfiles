--
-- copilot.lua
-- https://github.com/zbirenbaum/copilot.lua
--

return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
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
      qf = false,
    },
  },
}
