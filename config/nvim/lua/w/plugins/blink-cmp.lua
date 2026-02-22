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
      { 'rcarriga/cmp-dap' },
    },
  },
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      { 'kristijanhusak/vim-dadbod-completion', ft = 'mysql' },
      { 'Kaiser-Yang/blink-cmp-git', ft = 'gitcommit' },
      { 'Dynge/gitmoji.nvim', ft = 'gitcommit' },
      { 'wassimk/git-coauthors.nvim', dev = true },
      { 'wassimk/flipper-complete.nvim', dev = true },
      { 'wassimk/rails-fixture-complete.nvim', dev = true },
    },

    version = '1.*',
    opts = {
      keymap = {
        preset = 'default',
        ['<Tab>'] = {
          'snippet_forward',
          function()
            return require('sidekick').nes_jump_or_apply()
          end,
          function()
            return vim.lsp.inline_completion.get()
          end,
          'fallback',
        },
        ['<S-Tab>'] = {
          'snippet_backward',
          'fallback',
        },
        ['<C-u>'] = {
          'scroll_documentation_up',
          function(cmp)
            if cmp.snippet_active() then
              local has_luasnip, luasnip = pcall(require, 'luasnip')
              if has_luasnip and luasnip.choice_active() then
                vim.schedule(function()
                  -- schedule to avoid conflict with blink.cmp menu rendering
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
          'lsp',
          'snippets',
          'buffer',
          'path',
        },

        per_filetype = {
          ruby = { inherit_defaults = true, 'rails_fixtures', 'flipper_complete' },
          gitcommit = { 'buffer', 'snippets', 'gitmoji', 'git', 'git_coauthors' },
          mysql = { 'snippets', 'dadbod', 'buffer' },
          ['dap-repl'] = { 'dap' },
          ['dapui_watches'] = { 'dap' },
          ['dapui_hover'] = { 'dap' },
        },

        providers = {
          rails_fixtures = {
            name = 'rails_fixtures',
            module = 'rails-fixture-complete.blink',
          },
          flipper_complete = {
            name = 'flipper_complete',
            module = 'flipper-complete.blink',
          },
          git_coauthors = {
            name = 'git_coauthors',
            module = 'git-coauthors.blink',
            score_offset = 100,
          },
          dap = {
            name = 'dap',
            module = 'blink.compat.source',
          },
          git = {
            name = 'Git',
            module = 'blink-cmp-git',
            opts = {
              commit = { triggers = { ';' } },
              git_centers = { github = { mention = { enable = false } } },
            },
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
        },
      },

      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
