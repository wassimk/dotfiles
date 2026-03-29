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
  { 'mayromr/blink-cmp-dap', lazy = true },
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      { 'Kaiser-Yang/blink-cmp-git', ft = 'gitcommit' },
      { 'Dynge/gitmoji.nvim', ft = 'gitcommit' },
      { 'wassimk/git-coauthors.nvim', dev = true },
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
          gitcommit = { 'buffer', 'snippets', 'gitmoji', 'git', 'git_coauthors' },
          ['dap-repl'] = { 'dap' },
          ['dapui_watches'] = { 'dap' },
          ['dapui_hover'] = { 'dap' },
        },

        providers = {
          git_coauthors = {
            name = 'git_coauthors',
            module = 'git-coauthors.blink',
            score_offset = 100,
          },
          dap = {
            name = 'dap',
            module = 'blink-cmp-dap',
          },
          git = {
            name = 'Git',
            module = 'blink-cmp-git',
            -- Avoid conflicts with git-coauthors (@ on Co-Authored-By lines)
            -- and gitmoji (: on line 1). Both sources share triggers with blink-cmp-git.
            transform_items = function(_, items)
              if require('git-coauthors').is_coauthor_context() then
                return {}
              end
              -- When typing a gitmoji (:emoji on line 1), hide commit SHA completions
              if vim.fn.line('.') == 1 and vim.fn.getline('.'):match('^:') then
                local commit_kind = require('blink.cmp.types').CompletionItemKind.Commit
                return vim.tbl_filter(function(item)
                  return item.kind ~= commit_kind
                end, items)
              end
              return items
            end,
          },
          gitmoji = {
            name = 'gitmoji',
            module = 'gitmoji.blink',
            -- Only offer gitmoji when : is the first char on the subject line
            enabled = function()
              return vim.fn.line('.') == 1 and vim.fn.getline('.'):match('^:') ~= nil
            end,
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
