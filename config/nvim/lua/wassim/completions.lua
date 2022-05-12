local cmp = require('cmp')

local t = function(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

cmp.setup {
  snippet = {
    expand = function(args)
      require('snippy').expand_snippet(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      -- set a name for each source
      vim_item.menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        snippy = '[Snippet]',
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
    { name = 'buffer', dup = 0 }, { name = 'nvim_lsp' }, { name = 'snippy' }, { name = 'nvim_lua' },
    { name = 'path' }, { name = 'spell' }
  },
  completion = { completeopt = 'menu,menuone,noinsert' }
}

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Autopairs
require('nvim-autopairs').setup { check_ts = true, map_cr = true }
require('nvim-autopairs').add_rules(require('nvim-autopairs.rules.endwise-lua'))
require('nvim-autopairs').add_rules(require('nvim-autopairs.rules.endwise-ruby'))
