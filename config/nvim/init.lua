--
-- init.lua
--

pcall(require, 'impatient')

require('builtin_plugins').disable()
require('vim_plugins').setup()
require('plugins').setup()
require('w')
