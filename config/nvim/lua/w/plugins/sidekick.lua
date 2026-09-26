--
-- sidekick.nvim
-- https://github.com/folke/sidekick.nvim
--
-- Only the next-edit-suggestion half is used. The CLI half is replaced by
-- lua/w/herdr.lua, which runs Claude in a herdr pane instead.
--

return {
  'folke/sidekick.nvim',
  opts = {
    cli = {
      mux = {
        enabled = false,
      },
    },
  },
  keys = {
    {
      '<Tab>',
      function()
        if not require('sidekick').nes_jump_or_apply() then
          return '<Tab>'
        end
      end,
      expr = true,
      desc = 'accept NES',
    },
  },
}
