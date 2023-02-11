--
-- copilot.vim
-- https://github.com/github/copilot.vim
--

local has_copilot, _ = pcall(require, 'copilot')

if not has_copilot then
  return
end

-- it breaks dap and dapui
vim.g.copilot_filetypes = {
  ['dapui_scopes'] = false,
  ['dapui_breakpoints'] = false,
  ['dapui_stacks'] = false,
  ['dapui_watches'] = false,
  ['dap-repl'] = false,
  ['dapui_console'] = false,
}
