--
-- copilotchat.nvim
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
--

return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
    },
    opts = {
      context = 'buffers',
      window = {
        layout = 'float',
        relative = 'cursor',
        width = 1,
        height = 0.4,
        row = 1,
      },
    },
  },
}
