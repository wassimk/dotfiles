--
-- copilotchat.nvim
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
--

return {
  'CopilotC-Nvim/CopilotChat.nvim',
  cmd = { 'CopilotChat', 'CopilotChatExplain', 'CopilotChatCommitStaged' },
  dependencies = {
    { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
  },
  opts = {
    auto_insert_mode = true,
    context = 'buffers',
    window = {
      layout = 'horizontal',
    },
  },
}
