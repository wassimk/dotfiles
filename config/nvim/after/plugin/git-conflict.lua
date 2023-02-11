--
-- git-conflict.nvim
-- https://github.com/akinsho/git-conflict.nvim
--

local has_git_conflict, git_conflict = pcall(require, 'git-conflict')

if not has_git_conflict then
  return
end

git_conflict.setup({
  default_mappings = false,
  disable_diagnostics = true,
})
