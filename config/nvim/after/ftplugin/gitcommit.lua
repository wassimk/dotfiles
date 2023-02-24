--
-- gitcommit filetype
--

vim.o.spell = true

require('w.plugin.cmp.git_handles').setup()

-- TODO: move this source out of w.cmp_handles and into nvim-cmp.lua
require('cmp_git').setup()
