local cmp = require('cmp')
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
      require 'luasnip'.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      -- set a name for each source
      vim_item.menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        nvim_lsp_signature_help = '[Signature]',
        luasnip = '[Snippet]',
        nvim_lua = '[Lua]',
        path = '[Path]',
        spell = '[Spell]',
        git = '[GitHub]',
        rails_fixtures_names = '[Fixture Name]',
        rails_fixtures_types = '[Fixture Type]',
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
    { name = 'spell' },
    { name = 'git' },
    { name = 'rails_fixtures_names' },
    { name = 'rails_fixtures_types' },
  },
  completion = { completeopt = 'menu,menuone,noinsert' }
}

cmp.setup.cmdline('/', {
  mapping = key_mappings,
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = key_mappings,
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

require('cmp_git').setup()

-- Autopairs
local npairs = require('nvim-autopairs')
npairs.setup { check_ts = true, map_cr = true }
npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
