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
      trig = 'use_stripe_cassette',
      name = 'Stripe VCR Cassette (object)',
      dscr = 'Stripe VCR cassette with object from cassette data',
      hidden = true,
    },
    {
      t { 'use_stripe_cassette("' }, i(1, 'cassette-name'), t { '") do |cassette|', '' },
      t { '  ' }, i(2, 'stripe_object-name'), t { ' = stripe_object_from_cassette(cassette, path: "' }, i(3, 'request-path'), t { '", http_method: :' }, c(4, { t 'post', t 'get', t 'put', t 'delete' }), t { ')', '' },
      t { '  ' }, i(0),
      t { '', 'end' }
    }
  ),
  s(
    {
      trig = 'use_stripe_cassette',
      name = 'Stripe VCR Cassette (simple)',
      dscr = 'Stripe VCR cassette',
      hidden = true,
    },
    {
      t { 'use_stripe_cassette("' }, i(1), t { '") do', '' },
      t { '  ' }, i(0),
      t { '', 'end' }
    }
  )
}
