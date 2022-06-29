---@diagnostic disable: undefined-global

local has_luasnip, _ = pcall(require, 'luasnip')

if not has_luasnip then
  return
end

return {}
