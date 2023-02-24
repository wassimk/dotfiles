--
-- gitcommit filetype
--

vim.o.spell = true

require('w.plugin.cmp.git_handles').setup()
require('cmp_git').setup()
