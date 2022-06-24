local has_cmp, cmp = pcall(require, 'cmp')

if has_cmp then
  local has_luasnip, luasnip = pcall(require, 'luasnip')

  local key_mappings = {
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-y>'] = cmp.mapping(cmp.mapping.confirm(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
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
      format = function(entry, vim_item)
        vim_item.menu = ({
          buffer = '[Buffer]',
          nvim_lsp = '[LSP]',
          nvim_lsp_signature_help = '[Signature]',
          luasnip = '[Snippet]',
          nvim_lua = '[Lua]',
          path = '[Path]',
          spell = '[Spell]',
          git = '[GitHub]',
        })[entry.source.name]
        return vim_item
      end
    },

    mapping = key_mappings,

    sources = {
      { name = 'luasnip' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lua' },
      { name = 'buffer' },
      { name = 'spell', keyword_length = 4 },
      { name = 'git' },
    },

    completion = { completeopt = 'menu,menuone,noinsert' }
  }

  cmp.setup.cmdline('/', {
    mapping = key_mappings,

    formatting = {
      format = function(entry, vim_item)
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
      format = function(entry, vim_item)
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

require('cmp_git').setup()

-- Autopairs
local npairs = require('nvim-autopairs')
npairs.setup { check_ts = true, map_cr = true }
npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
