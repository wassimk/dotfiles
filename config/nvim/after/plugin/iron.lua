--
-- iron.nvim
-- https://github.com/hkupty/iron.nvim
--

if packer_plugins['iron.nvim'] and packer_plugins['iron.nvim'].loaded then
  require('iron.core').setup({
    config = {
      scratch_repl = true,
      repl_open_cmd = 'belowright 20 split',
    },
  })
end
