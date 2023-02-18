--
-- luasnip.nvim
-- https://github.com/L3MON4D3/LuaSnip
--

local has_luasnip, luasnip = pcall(require, 'luasnip')

if not has_luasnip then
  return
end

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
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true })

-- reload snippets
vim.keymap.set(
  'n',
  '<leader><leader>s',
  '<cmd>source ' .. os.getenv('HOME') .. '/.config/nvim/after/plugin/luasnip.lua<CR>',
  { noremap = true, silent = true }
)

require('luasnip.loaders.from_lua').load({ paths = os.getenv('HOME') .. '/.config/nvim/lua/wassim/snippets' })
