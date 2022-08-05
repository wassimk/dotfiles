--
-- nvim-cmp
-- https://github.com/hrsh7th/nvim-cmp
--

if packer_plugins['nvim-cmp'] and packer_plugins['nvim-cmp'].loaded then
  local cmp = require('cmp')
  local lspkind = require('lspkind')
  local luasnip = pcall(require, 'luasnip')

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

    formatting = {
      format = lspkind.cmp_format({
        mode = 'symbol',
        before = function(entry, vim_item)
          vim_item.menu = ({
            buffer = '[Buffer]',
            feature_flipper = '[Flipper]',
            git = '[GitHub]',
            luasnip = '[Snippet]',
            nvim_lsp = '[LSP]',
            nvim_lsp_signature_help = '[Signature]',
            nvim_lua = '[Neovim]',
            path = '[Path]',
            rails_fixture_names = '[Fixture]',
            rails_fixture_types = '[Fixture]',
            spell = '[Spell]',
            treesitter = '[Treesitter]',
          })[entry.source.name]
          return vim_item
        end,
      }),
    },

    mapping = key_mappings,

    sources = {
      { name = 'rails_fixture_names' },
      { name = 'rails_fixture_types' },
      { name = 'feature_flipper' },
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lua' },
      { name = 'treesitter' },
      { name = 'buffer' },
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
end
