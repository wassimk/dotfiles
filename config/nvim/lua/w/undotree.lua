--
-- undotree
--
-- Built-in optional plugin (Neovim 0.12+) that draws the undo tree,
-- including branches that u and <C-r> can't reach, with a diff per state.
--

vim.cmd.packadd('nvim.undotree')

vim.keymap.set('n', '<Leader>u', vim.cmd.Undotree, { desc = 'undo tree' })
