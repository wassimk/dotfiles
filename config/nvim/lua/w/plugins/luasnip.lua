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

    vim.keymap.set({ 'i', 's' }, '<C-k>', function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { desc = 'LUASNIP: expand or jump next' })

    vim.keymap.set({ 'i', 's' }, '<C-j>', function()
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      end
    end, { desc = 'LUASNIP: jump previous' })

    local snippets_dir = os.getenv('HOME') .. '/.config/nvim/lua/w/custom/luasnip/snippets'
    local load_snippets = function()
      require('luasnip.loaders.from_lua').load({
        paths = snippets_dir,
      })
    end

    -- reload snippets helper keymap
    vim.keymap.set('n', '<leader><leader>s', load_snippets, { desc = 'LUASNIP: reload keymaps' })

    -- initial snippet load
    load_snippets()
  end,
}
