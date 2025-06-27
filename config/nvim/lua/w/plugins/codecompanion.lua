--
-- codecompanion.nvim
-- https://github.com/olimorris/codecompanion.nvim
--

return {
  'olimorris/codecompanion.nvim',
  cmd = {
    'CodeCompanion',
    'CodeCompanionActions',
    'CodeCompanionChat',
    'CodeCompanionCmd',
  },
  opts = {
    extensions = {
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = {
          make_vars = true,
          make_slash_commands = true,
          show_result_in_chat = true,
        },
      },
    },
    display = {
      chat = {
        intro_message = nil,
        start_in_insert_mode = true,
      },
      diff = {
        enabled = true,
        provider = 'mini_diff',
      },
    },
    strategies = {
      chat = {
        adapter = {
          name = 'copilot',
          model = 'claude-3.7-sonnet',
        },
        completion_provider = 'blink',
        roles = {
          llm = function(adapter)
            if adapter.name == 'copilot' then
              return '  Copilot'
            else
              return 'icon  ' .. adapter.formatted_name
            end
          end,
          user = function()
            local username = vim.env.USER or 'User'
            return username:sub(1, 1):upper() .. username:sub(2)
          end,
        },
      },
    },
  },
  keys = {
    { '<leader>ac', '', desc = '+Code Companion', mode = { 'n', 'v' } },
    {
      '<leader>aca',
      function()
        require('codecompanion').toggle()
      end,
      desc = 'AI: toggle',
      mode = { 'n', 'v' },
    },
    {
      '<leader>acx',
      function()
        require('codecompanion').refresh_cache()
      end,
      desc = 'AI: refresh cache',
      mode = { 'n', 'v' },
    },
    {
      '<leader>acq',
      function()
        local input = vim.fn.input('Quick Chat: ')
        if input ~= '' then
          vim.cmd('CodeCompanion ' .. input)
        end
      end,
      desc = 'AI: quick chat',
      mode = { 'n', 'v' },
    },
    {
      '<leader>acp',
      '<cmd>CodeCompanionActions<cr>',
      desc = 'AI: actions',
      mode = { 'n', 'v' },
    },
  },
  dependencies = {
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = { 'codecompanion' },
    },
  },
}
