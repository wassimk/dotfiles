--
-- init.lua
--

pcall(require, 'impatient')

-- remap leader and local leader to <Space>
-- here because lazy.nvim wants this to happen first
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', {})
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('plugins').setup()
require('w')
