--
-- copilot.lua
-- https://github.com/zbirenbaum/copilot.lua
--

return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    copilot_node_command = vim.fn.system('devbox global path'):gsub('%s+$', '')
      .. '/.devbox/nix/profile/default/bin/node',
    panel = { enabled = false },
    suggestion = { enabled = false },
    filetypes = {
      help = true,
      markdown = true,
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
