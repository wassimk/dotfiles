--
-- ChatGPT
-- https://github.com/jackMort/ChatGPT.nvim
--

return {
  'jackMort/ChatGPT.nvim',
  cmd = { 'ChatGPT', 'ChatGPTRun', 'ChatGPTActAs', 'ChatGPTEditWithInstructions' },
  config = function()
    require('chatgpt').setup({
      api_key_cmd = 'op read op://System/openai/credential',
    })
  end,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
}
