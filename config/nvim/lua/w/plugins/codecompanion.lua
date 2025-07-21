--
-- codecompanion.nvim, mcphub.nvim
-- https://github.com/olimorris/codecompanion.nvim
-- https://github.com/ravitemer/mcphub.nvim
-- https://github.com/echasnovski/mini.diff
-- https://github.com/MeanderingProgrammer/render-markdown.nvim
--

return {
  {
    'Joakker/lua-json5',
    build = './install.sh',
  },
  {
    'ravitemer/mcphub.nvim',
    cmd = { 'MCPHub' },
    build = 'npm install -g mcp-hub@latest',
    config = function()
      require('mcphub').setup({ -- must run setup for json_decode to work
        json_decode = require('json5').parse,
      })
    end,
  },
  {
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
          adapter = { name = 'copilot' },
          inline = { name = 'copilot' },
          cmd = { name = 'copilot' },
          completion_provider = 'blink',
          roles = {
            llm = function(adapter)
              local adapter_and_model = adapter.formatted_name .. ' (' .. adapter.model.name .. ')'

              if adapter.name == 'copilot' then
                return ' ' .. adapter_and_model
              else
                return ' ' .. adapter_and_model
              end
            end,
            user = ' Me',
          },
        },
      },
      adapters = {
        copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
            schema = {
              model = {
                default = 'claude-sonnet-4',
              },
            },
          })
        end,
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
      {
        'zbirenbaum/copilot.lua',
      },
      {
        'echasnovski/mini.diff',
        config = function()
          local diff = require('mini.diff')
          diff.setup({
            -- Disabled by default, codecompanion.nvim will call it
            source = diff.gen_source.none(),
          })
        end,
      },
    },
  },
}
