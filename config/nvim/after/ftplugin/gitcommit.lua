vim.o.spell = true

require('wassim.cmp_handles').setup()

-- TODO: move this source out of wassim.cmp_handles and into nvim-cmp.lua
require('cmp_git').setup()
