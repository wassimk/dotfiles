---@diagnostic disable: undefined-global

local has_luasnip, _ = pcall(require, 'luasnip')

if not has_luasnip then
  return
end

-- If ~/.github-handles.json exists, use it via completion, otherwise fallback to this.
local cab = (vim.fn.filereadable(vim.fn.expand('~/.github-handles.json')) == 1) and
    fmt('Co-Authored-By: {}', {
      i(1, '@handle'),
    }) or
    fmt('Co-Authored-By: {} <{}@{}>', {
      i(1, 'Name'),
      i(2, 'user'),
      i(3, 'github.com'),
    })

return {
  s(
    { trig = 'cab', dscr = 'Co-Authored-By:' },
    cab
  ),
}
