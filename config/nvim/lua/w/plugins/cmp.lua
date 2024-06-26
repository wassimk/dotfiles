--
-- nvim-cmp
-- https://github.com/hrsh7th/nvim-cmp
--

return {
  'hrsh7th/nvim-cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  dependencies = {
    'f3fora/cmp-spell',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',
    'petertriho/cmp-git',
    'ray-x/cmp-treesitter',
    'rcarriga/cmp-dap',
    { 'kristijanhusak/vim-dadbod-completion', ft = 'sql' },
    { 'wassimk/cmp-rails-fixture-types', ft = 'ruby', dev = true },
    { 'wassimk/cmp-rails-fixture-names', ft = 'ruby', dev = true },
    { 'wassimk/cmp-feature-flipper', dev = true },
  },
  config = function()
    local cmp = require('cmp')
    local lspkind = require('lspkind')
    local has_luasnip, luasnip = pcall(require, 'luasnip')

    local key_mappings = {
      ['<C-p>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif has_luasnip and luasnip.choice_active() then
          luasnip.change_choice(-1)
        else
          fallback()
        end
      end, { 'i', 'c' }),

      ['<C-n>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_luasnip and luasnip.choice_active() then
          luasnip.change_choice(1)
        else
          fallback()
        end
      end, { 'i', 'c' }),

      ['<C-u>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.scroll_docs(-4)
        elseif has_luasnip and luasnip.choice_active() then
          require('luasnip.extras.select_choice')()
        else
          fallback()
        end
      end, { 'i', 's' }),

      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-y>'] = cmp.mapping(cmp.mapping.confirm(), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          if has_luasnip then
            luasnip.lsp_expand(args.body)
          end
        end,
      },

      window = {
        -- completion = cmp.config.window.bordered({ border = 'single' }),
        -- documentation = cmp.config.window.bordered({ border = 'single' }),
      },

      enabled = function()
        return vim.api.nvim_buf_get_option(0, 'buftype') ~= 'prompt' or require('cmp_dap').is_dap_buffer()
      end,

      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          preset = 'codicons',
          before = function(entry, vim_item)
            vim_item.menu = ({
              buffer = '[Buffer]',
              dap = '[DAP]',
              feature_flipper = '[Flipper]',
              git = '[GitHub]',
              luasnip = '[Snippet]',
              nvim_lsp = '[LSP]',
              nvim_lsp_signature_help = '[Signature]',
              path = '[Path]',
              rails_fixture_names = '[Fixture]',
              rails_fixture_types = '[Fixture]',
              spell = '[Spell]',
              treesitter = '[Treesitter]',
            })[entry.source.name]

            vim_item.dup = { feature_flipper = 1, nvim_lsp = 0 }

            return vim_item
          end,
        }),
      },

      mapping = key_mappings,

      sources = {
        { name = 'lazydev', group_index = 0 },
        { name = 'rails_fixture_types', priority = 10 },
        { name = 'rails_fixture_names', priority = 9 },
        { name = 'feature_flipper', priority = 8 },
        { name = 'buffer' },
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'treesitter' },
        { name = 'spell', keyword_length = 4 },
      },

      completion = { completeopt = 'menu,menuone,noinsert' },
    })

    cmp.setup.cmdline('/', {
      mapping = key_mappings,

      formatting = {
        format = function(_, vim_item)
          vim_item.kind = nil
          vim_item.source = nil

          return vim_item
        end,
      },

      sources = {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = key_mappings,

      formatting = {
        format = function(_, vim_item)
          vim_item.kind = nil

          return vim_item
        end,
      },

      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        { name = 'cmdline' },
      }),
    })

    cmp.setup.filetype({ 'sql' }, {
      sources = {
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
      },
    })

    cmp.setup.filetype({ 'dap-repl', 'dapui_watches', 'dapui_hover' }, {
      formatting = {
        format = function(_, vim_item)
          vim_item.kind = nil
          vim_item.source = nil

          return vim_item
        end,
      },

      sources = {
        { name = 'dap' },
      },
    })

    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        { name = 'luasnip' }, -- for cab~
        { name = 'buffer' },
        { name = 'path' },
        { name = 'git_handles', priority = 10 },
        { name = 'git', priority = 9 },
        { name = 'spell', keyword_length = 4 },
      }),
    })

    -- support nvim-autopairs with cmp
    local has_auto_pairs, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
    if has_auto_pairs then
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end
  end,
}
