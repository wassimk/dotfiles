--
-- blink.cmp, blink.compat
-- https://github.com/Saghen/blink.cmp
-- https://github.com/Saghen/blink.compat
--

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuOpen',
  callback = function()
    vim.g.snacks_animate = false
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuClose',
  callback = function()
    vim.g.snacks_animate = true
  end,
})

return {
  {
    'saghen/blink.compat',
    version = '2.*',
    lazy = true,
    opts = {},
    dependencies = {
      { 'wassimk/cmp-rails-fixture-types' },
      { 'wassimk/cmp-rails-fixture-names' },
      { 'wassimk/cmp-feature-flipper' },
      { 'rcarriga/cmp-dap' },
    },
  },
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      { 'onsails/lspkind.nvim' }, -- uses Blink highlights for LSP document symbols in qf
      { 'kristijanhusak/vim-dadbod-completion', ft = 'mysql' },
      { 'Kaiser-Yang/blink-cmp-git', ft = 'gitcommit' },
      { 'Dynge/gitmoji.nvim', ft = 'gitcommit' },
      { 'fang2hou/blink-copilot' },
    },

    version = '1.*',
    opts = {
      keymap = {
        preset = 'default',
        ['<C-u>'] = {
          'scroll_documentation_up',
          function(cmp)
            if cmp.snippet_active() then
              local has_luasnip, luasnip = pcall(require, 'luasnip')
              if has_luasnip and luasnip.choice_active() then
                vim.schedule(function() -- address a bug
                  require('luasnip.extras.select_choice')()
                end)
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
          'lazydev',
          'copilot',
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
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 100,
            async = true,
          },
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
