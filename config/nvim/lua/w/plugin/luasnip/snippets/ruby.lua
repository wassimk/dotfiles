---@diagnostic disable: undefined-global

local has_luasnip, _ = pcall(require, 'luasnip')

if not has_luasnip then
  return
end

local cassettes_dir = function()
  local folders = { './test/vcr_cassettes', './spec/vcr_cassettes' }

  local cassettes_dir = ''

  for _, folder_path in ipairs(folders) do
    if vim.fn.isdirectory(folder_path) == 1 then
      cassettes_dir = folder_path
    end
  end

  return cassettes_dir
end

local cassettes = function()
  local cassettes = {}

  vim.fs.find(function(name, _)
    local cassette = name:match('^stripe%-(.+)%.yml$')

    if cassette ~= nil then
      table.insert(cassettes, cassette)
    end

    return false
  end, { upward = false, path = cassettes_dir(), limit = math.huge, type = 'file' })

  table.sort(cassettes)

  return cassettes
end

local cassette_choices = function()
  local cassette_nodes = {}

  for _, cassette in ipairs(cassettes()) do
    table.insert(cassette_nodes, t(cassette))
  end

  if not next(cassette_nodes) then
    return { t('unable to load cassette choices from ' .. cassettes_dir()) }
  else
    return cassette_nodes
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
          {} = stripe_object_from_cassette(cassette, http_method: :{}, path: "{}")
          {}
        end
      ]],
      {
        c(1, cassette_choices()),
        i(2, 'stripe_object_name'),
        c(3, { t('get'), t('post'), t('put'), t('delete') }),
        i(4, 'request-path'),
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
      { c(1, cassette_choices()), i(0) }
    )
  ),
}
