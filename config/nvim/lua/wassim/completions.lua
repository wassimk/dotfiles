local cmp = require('cmp')

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
        spell = '[Spell]'
      })[entry.source.name]
      return vim_item
    end
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
    { name = 'buffer' },
    { name = 'spell' }
  },
  completion = { completeopt = 'menu,menuone,noinsert' }
}

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Autopairs
npairs = require('nvim-autopairs')
npairs.setup { check_ts = true, map_cr = true }
npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
