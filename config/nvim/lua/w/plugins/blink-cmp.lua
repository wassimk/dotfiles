--
-- blink.cmp
-- https://github.com/Saghen/blink.cmp
--

return {
  {
    'saghen/blink.compat',
    version = '2.*',
    lazy = true,
    opts = {},
  },

  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      { 'onsails/lspkind.nvim' }, -- uses Blink highlights for LSP document symbols in qf
      { 'rcarriga/cmp-dap' },
      { 'kristijanhusak/vim-dadbod-completion', ft = 'mysql' },
      { 'Kaiser-Yang/blink-cmp-git', ft = 'gitcommit' },
      { 'Dynge/gitmoji.nvim', ft = 'gitcommit' },
      { 'wassimk/cmp-rails-fixture-types', ft = 'ruby', dev = true },
      { 'wassimk/cmp-rails-fixture-names', ft = 'ruby', dev = true },
      { 'wassimk/cmp-feature-flipper', dev = true },
    },

    version = '1.*',
    opts = {
      keymap = {
        preset = 'default',
        ['<C-u>'] = {
          'scroll_documentation_up',
          function(cmp)
            local has_luasnip, luasnip = pcall(require, 'luasnip')
            if cmp.snippet_active() then
              if has_luasnip and luasnip.choice_active() then
                require('luasnip.extras.select_choice')()
              end
            end
          end,
        },
        ['<C-d>'] = { 'scroll_documentation_down' },
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },

      snippets = { preset = 'luasnip' },

      cmdline = {
        completion = {
          menu = {
            draw = {
              columns = {
                { 'label', 'label_description', gap = 1 },
              },
            },
            auto_show = true,
          },
        },

        sources = function()
          local type = vim.fn.getcmdtype()
          if type == '/' or type == '?' then
            return { 'buffer' }
          end
          if type == ':' or type == '@' then
            return { 'cmdline', 'buffer' }
          end
          return {}
        end,
      },

      sources = {
        default = {
          'lsp',
          'snippets',
          'buffer',
          'path',
        },

        per_filetype = {
          ruby = { inherit_defaults = true, 'rails_fixture_types', 'rails_fixture_names', 'feature_flipper' },
          gitcommit = { 'buffer', 'snippets', 'gitmoji', 'git', 'git_handles' },
          mysql = { 'snippets', 'dadbod', 'buffer' },
          ['dap-repl'] = { 'dap' },
          ['dapui_watches'] = { 'dap' },
          ['dapui_hover'] = { 'dap' },
        },

        providers = {
          rails_fixture_types = {
            name = 'rails_fixture_types',
            module = 'blink.compat.source',
          },
          rails_fixture_names = {
            name = 'rails_fixture_names',
            module = 'blink.compat.source',
          },
          feature_flipper = {
            name = 'feature_flipper',
            module = 'blink.compat.source',
          },
          git_handles = {
            name = 'git_handles',
            module = 'blink.compat.source',
          },
          dap = {
            name = 'dap',
            module = 'blink.compat.source',
          },
          git = {
            name = 'Git',
            module = 'blink-cmp-git',
            opts = { commit = { triggers = { ';' } } },
          },
          dadbod = {
            name = 'Dadbod',
            module = 'vim_dadbod_completion.blink',
          },
          gitmoji = {
            name = 'gitmoji',
            module = 'gitmoji.blink',
          },
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
