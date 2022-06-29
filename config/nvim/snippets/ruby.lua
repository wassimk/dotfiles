---@diagnostic disable: undefined-global

local has_luasnip, _ = pcall(require, 'luasnip')

if not has_luasnip then
  return
end

return {
  s({
    trig = 'rl',
    namr = 'Rails Logger',
    dscr = 'Write to the built-in Rails logger'
  },

    { t { "Rails.logger.info '#' * 50", 'Rails.logger.info ', }, i(0, 'data_to_log'), t { '', "Rails.logger.info '#' * 50" } }
  )
}
