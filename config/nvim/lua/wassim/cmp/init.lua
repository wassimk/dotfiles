local has_cmp, cmp = pcall(require, 'cmp')

if has_cmp then
  local has_luasnip, luasnip = pcall(require, 'luasnip')
  local lspkind = require('lspkind')

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
        require 'luasnip.extras.select_choice' ()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-y>'] = cmp.mapping(cmp.mapping.confirm(), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
  }

  cmp.setup {
    snippet = {
      expand = function(args)
        if has_luasnip then
          luasnip.lsp_expand(args.body)
        end
      end,
    },

    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },

    formatting = {
      format = lspkind.cmp_format {
        mode = 'symbol',
        before = function(entry, vim_item)
          vim_item.menu = ({
            luasnip = '[Snippet]',
            nvim_lsp_signature_help = '[Signature]',
            rails_fixture_types = '[Fixture]',
            rails_fixture_names = '[Fixture]',
            buffer = '[Buffer]',
            nvim_lsp = '[LSP]',
            nvim_lua = '[Neovim]',
            path = '[Path]',
            spell = '[Spell]',
            git = '[GitHub]',
          })[entry.source.name]
          return vim_item
        end
      }
    },

    mapping = key_mappings,

    sources = {
      { name = 'rails_fixture_names' },
      { name = 'rails_fixture_types' },
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lua' },
      { name = 'buffer' },
      { name = 'spell', keyword_length = 4 },
    },

    completion = { completeopt = 'menu,menuone,noinsert' }
  }

  cmp.setup.cmdline('/', {
    mapping = key_mappings,

    formatting = {
      format = function(_, vim_item)
        vim_item.kind = nil
        vim_item.source = nil

        return vim_item
      end
    },

    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    mapping = key_mappings,

    formatting = {
      format = function(_, vim_item)
        vim_item.kind = nil

        return vim_item
      end
    },

    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end
