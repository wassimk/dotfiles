--
-- copilotchat.nvim
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
--

return {
  'CopilotC-Nvim/CopilotChat.nvim',
  cmd = { 'CopilotChat', 'CopilotChatExplain', 'CopilotChatCommitStaged' },
  branch = 'canary',
  dependencies = {
    { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
  },
  opts = {
    context = 'buffers',
    window = {
      layout = 'horizontal',
    },
  },
}
