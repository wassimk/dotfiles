---@diagnostic disable: undefined-global

local has_luasnip, _ = pcall(require, 'luasnip')

if not has_luasnip then
  return
end

return {
  s(
    {
      trig = 'rl',
      name = 'Rails Logger',
      dscr = 'Write to the built-in Rails logger'
    },
    {
      t { "Rails.logger.info '#' * 50", 'Rails.logger.info ', },
      i(0, 'data_to_log'),
      t { '', "Rails.logger.info '#' * 50" }
    }
  ),
  s(
    {
      trig = 'usca',
      name = 'use_stripe_cassette',
      dscr = 'Stripe VCR cassette with object from cassette data',
      hidden = false,
    },
    fmt(
      [[
        use_stripe_cassette("{}") do |cassette|
          {} = stripe_object_from_cassette(cassette, path: "{}", http_method: :{})
          {}
        end
      ]], { i(1, 'cassette-name'), i(2, 'stripe_object_name'), i(3, 'request-path'), c(4, { t 'get', t 'post', t 'put', t 'delete' }), i(0) }
    )
  ),
  s(
    {
      trig = 'uscs',
      name = 'use_stripe_cassette',
      dscr = 'Stripe VCR cassette',
      hidden = false,
    },
    fmt(
      [[
        use_stripe_cassette("{}") do
          {}
        end
      ]], { i(1), i(0) }
    )
  )
}
