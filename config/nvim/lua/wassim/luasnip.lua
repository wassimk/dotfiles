local has_luasnip, luasnip = pcall(require, 'luasnip')

if has_luasnip then
  local types = require('luasnip.util.types')

  luasnip.config.setup {
    history = true,
    update_events = 'InsertLeave,TextChangedI',
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { '← Choice' } },
        },
      },
      -- [types.insertNode] = {
      --   active = {
      --     virt_text = { { '← ...', 'Todo' } },
      --   },
      -- },
    },
    -- store_selection_keys = '<Tab>',
    -- enable_autosnippets = true,
  }

  require('luasnip.loaders.from_lua').load { paths = '~/.config/nvim/snippets' }
end
