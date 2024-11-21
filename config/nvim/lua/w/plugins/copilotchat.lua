--
-- copilotchat.nvim
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
--

local M = {}

---@param kind string
function M.pick(kind)
  return function()
    local actions = require('CopilotChat.actions')
    local items = actions[kind .. '_actions']()
    if not items then
      vim.notify('No ' .. kind .. ' found on the current line')
      return
    end
    local ok = pcall(require, 'fzf-lua')
    require('CopilotChat.integrations.' .. (ok and 'fzflua' or 'telescope')).pick(items)
  end
end

return {
  'CopilotC-Nvim/CopilotChat.nvim',
  cmd = { 'CopilotChat', 'CopilotChatExplain', 'CopilotChatCommitStaged' },
  dependencies = {
    { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
  },

  opts = function()
    local user = vim.env.USER or 'User'
    user = user:sub(1, 1):upper() .. user:sub(2)

    return {
      context = 'buffers',
      answer_header = '  Copilot ',
      question_header = '  ' .. user .. ' ',
      chat_autocomplete = true,
      auto_insert_mode = true,
      selection = function(source)
        local select = require('CopilotChat.select')
        return select.visual(source) or select.buffer(source)
      end,
      window = {
        layout = 'horizontal',
      },
    }
  end,

  config = function(_, opts)
    local chat = require('CopilotChat')

    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'copilot-chat',
      callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
      end,
    })

    chat.setup(opts)
  end,

  keys = {
    { '<leader>a', '', desc = '+ai prefix', mode = { 'n', 'v' } },
    {
      '<leader>aa',
      function()
        return require('CopilotChat').toggle()
      end,
      desc = 'COPILOTCHAT: Toggle',
      mode = { 'n', 'v' },
    },
    {
      '<leader>ax',
      function()
        return require('CopilotChat').reset()
      end,
      desc = 'COPILOTCHAT: Clear/Reset',
      mode = { 'n', 'v' },
    },
    {
      '<leader>aq',
      function()
        local input = vim.fn.input('Quick Chat: ')
        if input ~= '' then
          require('CopilotChat').ask(input)
        end
      end,
      desc = 'COPILOTCHAT: Quick Chat',
      mode = { 'n', 'v' },
    },
    { '<leader>ad', M.pick('help'), desc = 'COPILOTCHAT: Diagnostic Help', mode = { 'n', 'v' } },
    { '<leader>ap', M.pick('prompt'), desc = 'COPILOTCHAT: Prompt Actions', mode = { 'n', 'v' } },
  },
}
