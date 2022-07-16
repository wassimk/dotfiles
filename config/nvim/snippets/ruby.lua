---@diagnostic disable: undefined-global

local has_luasnip, _ = pcall(require, 'luasnip')

if not has_luasnip then
  return
end

-- TODO: don't require plenary, can do this with Lua easier because we don't need folder depth
local cassettes = function()
  local cassettes_dir = './test/vcr_cassettes'

  local files = require('plenary.scandir').scan_dir(
    cassettes_dir,
    { search_pattern = '.yml', respect_gitignore = true, depth = 1, silent = true }
  )

  local cassettes = {}
  for _, file in ipairs(files) do
    local cassette = file:match(cassettes_dir .. '/stripe%-(.+)%.yml$')

    if cassette ~= nil then
      table.insert(cassettes, t(cassette))
    end
  end

  if not next(cassettes) then
    return { t('unable to load cassette choices from ' .. cassettes_dir) }
  else
    return cassettes
  end
end

return {
  s(
    {
      trig = 'rl',
      name = 'Rails Logger',
      dscr = 'Write to the built-in Rails logger',
    },
    fmt(
      [[
        Rails.logger.info "#" * 50
        Rails.logger.info {}
        Rails.logger.info "#" * 50
      ]],
      { i(0, 'data_to_log') }
    )
  ),
  s(
    {
      trig = 'usca',
      name = 'use_stripe_cassette (advanced)',
      dscr = 'Stripe VCR cassette with object from cassette data',
      hidden = false,
    },
    fmt(
      [[
        use_stripe_cassette("{}") do |cassette|
          {} = stripe_object_from_cassette(cassette, path: "{}", http_method: :{})
          {}
        end
      ]],
      {
        c(1, cassettes()),
        i(2, 'stripe_object_name'),
        i(3, 'request-path'),
        c(4, { t('get'), t('post'), t('put'), t('delete') }),
        i(0),
      }
    )
  ),
  s(
    {
      trig = 'uscs',
      name = 'use_stripe_cassette (simple)',
      dscr = 'Stripe VCR cassette',
      hidden = false,
    },
    fmt(
      [[
        use_stripe_cassette("{}") do
          {}
        end
      ]],
      { c(1, cassettes()), i(0) }
    )
  ),
}
