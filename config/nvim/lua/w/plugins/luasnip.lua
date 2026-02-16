--
-- luasnip.nvim
-- https://github.com/L3MON4D3/LuaSnip
--

return {
  'L3MON4D3/LuaSnip',
  event = 'InsertEnter',
  version = '*',
  config = function()
    local luasnip = require('luasnip')

    local types = require('luasnip.util.types')

    luasnip.config.setup({
      history = true,
      update_events = 'TextChanged,TextChangedI',
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { '←  Choice', 'Comment' } },
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
    })

    -- snippet navigation handled by blink.cmp Tab/S-Tab keymap chains

    local snippets_dir = os.getenv('HOME') .. '/.config/nvim/lua/w/custom/luasnip/snippets'
    local load_snippets = function()
      require('luasnip.loaders.from_lua').load({
        paths = snippets_dir,
      })
    end

    -- reload snippets helper keymap
    vim.keymap.set('n', '<leader><leader>s', load_snippets, { desc = 'luasnip: reload snippets' })

    -- initial snippet load
    load_snippets()
  end,
}
