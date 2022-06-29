vim.o.spell = true

require 'wassim.cmp.handles'.setup()

-- TODO: move the git handle out of wassim.cmp.handles and back into cmp/init.lua
require('cmp_git').setup()
