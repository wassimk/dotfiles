--
-- gitcommit filetype
--

vim.o.spell = true
vim.opt_local.formatoptions:append('a')

require('w.plugin.cmp.git_handles').setup()
require('cmp_git').setup()
