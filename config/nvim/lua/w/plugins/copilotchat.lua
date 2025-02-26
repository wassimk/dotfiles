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
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'main',
    cmd = 'CopilotChat',
    opts = function()
      local user = vim.env.USER or 'User'
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        question_header = '  ' .. user .. ' ',
        answer_header = '  Copilot ',
        window = {
          layout = 'horizontal',
        },
        model = 'claude-3.7-sonnet',
        contexts = {
          file = {
            input = function(callback)
              local telescope = require('telescope.builtin')
              local actions = require('telescope.actions')
              local action_state = require('telescope.actions.state')
              telescope.find_files({
                attach_mappings = function(prompt_bufnr)
                  actions.select_default:replace(function()
                    actions.close(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    callback(selection[1])
                  end)
                  return true
                end,
              })
            end,
          },
        },
      }
    end,
    keys = {
      { '<c-s>', '<CR>', ft = 'copilot-chat', desc = 'Submit Prompt', remap = true },
      { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
      {
        '<leader>aa',
        function()
          return require('CopilotChat').toggle()
        end,
        desc = 'COPILOT: Toggle',
        mode = { 'n', 'v' },
      },
      {
        '<leader>ax',
        function()
          return require('CopilotChat').reset()
        end,
        desc = 'COPILOT: clear',
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
        desc = 'COPILOT: Quick Chat',
        mode = { 'n', 'v' },
      },
      -- Show prompts actions with telescope
      { '<leader>ap', M.pick('prompt'), desc = 'COPILOT: Prompt Actions', mode = { 'n', 'v' } },
    },
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
  },
}
