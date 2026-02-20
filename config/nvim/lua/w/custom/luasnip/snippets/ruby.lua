---@diagnostic disable: undefined-global

local has_luasnip, _ = pcall(require, 'luasnip')

if not has_luasnip then
  return
end

local table_to_choices = function(tbl)
  local choices = {}

  for _, choice in pairs(tbl or {}) do
    table.insert(choices, t(choice))
  end

  if vim.tbl_isempty(choices) then
    return { t('unable to load choices') }
  else
    return choices
  end
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
  -- let's ignore boolegs for now
  local bootlegs_dir = cassettes_dir() .. '/bootlegs'

  vim.fs.find(function(name, _)
    local cassette = name:match('^stripe%-(.+)%.yml$')

    if cassette ~= nil then
      table.insert(cassettes, cassette)
    end

    return false -- a boolean return is expected
  end, { upward = false, stop = bootlegs_dir, path = cassettes_dir(), limit = math.huge, type = 'file' })

  table.sort(cassettes)

  return cassettes
end

local clean_stripe_path = function(path)
  local prefixes = {
    'tok',
    'btok',
    'src',
    'cus',
    'card',
    'ba',
    'ch',
    'py',
    're',
    'txn',
    'tr',
    'po',
    'acct',
    'dp',
    'evt',
    'pm',
    'seti',
    'pi',
    'mandate',
  }

  for _, prefix in ipairs(prefixes) do
    path = string.gsub(path, prefix .. '_%w+', prefix .. '_xxx')
  end

  return path
end

local cassette_paths = function(cassette_name)
  local filename = cassettes_dir() .. '/stripe-' .. cassette_name .. '.yml'

  local cassette = io.open(filename, 'r')

  if not cassette then
    vim.notify('Cannot open cassette file: ' .. filename, vim.log.levels.ERROR)
    return
  end

  local paths = {}
  for line in cassette:lines() do
    local path = line:match('uri: .+api.stripe.com/v1/(.+)')

    if path ~= nil then
      path = clean_stripe_path(path)
      if not vim.tbl_contains(paths, path) then
        table.insert(paths, path)
      end
    end
  end

  cassette:close()

  table.sort(paths)

  return paths
end

local bootleg_cassettes = function()
  local bootlegs = {}
  local bootlegs_dir = cassettes_dir() .. '/bootlegs'

  vim.fs.find(function(name, _)
    local cassette = name:match('^stripe%-(.+)%.yml$')

    if cassette ~= nil then
      table.insert(bootlegs, cassette)
    end

    return false
  end, { upward = false, path = bootlegs_dir, limit = math.huge, type = 'file' })

  table.sort(bootlegs)

  return bootlegs
end

local cassette_choices = function()
  return table_to_choices(cassettes())
end

local bootleg_cassette_choices = function()
  return table_to_choices(bootleg_cassettes())
end

local cassette_path_choices = function(cassette_name)
  return table_to_choices(cassette_paths(cassette_name))
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
        d(4, function(args)
          return sn(nil, { c(1, cassette_path_choices(args[1][1])) })
        end, { 1 }),
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
  s(
    {
      trig = 'uscb',
      name = 'use_stripe_bootleg',
      dscr = 'Stripe VCR bootleg cassette',
      hidden = false,
    },
    fmt(
      [[
        use_stripe_bootleg("{}") do
          {}
        end
      ]],
      { c(1, bootleg_cassette_choices()), i(0) }
    )
  ),
}
