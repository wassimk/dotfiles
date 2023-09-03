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
  local bootlegs_dir = cassettes_dir() .. '/bootlegs'

  vim.fs.find(function(name, _)
    local cassette = name:match('^stripe%-(.+)%.yml$')

    if cassette ~= nil then
      table.insert(cassettes, cassette)
    end

    return false
  end, { upward = false, stop = bootlegs_dir, path = cassettes_dir(), limit = math.huge, type = 'file' })

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

local cassette_paths = function(cassette_name)
  local filename = cassettes_dir() .. '/stripe-' .. cassette_name .. '.yml'

  local cassette = io.open(filename, 'r')

  if not cassette then
    vim.notify('Cannot open file: ' .. filename, vim.log.levels.ERROR)
    return
  end

  local paths = {}
  for line in cassette:lines() do
    local path = line:match('uri: (.+)')

    if path ~= nil and not vim.tbl_contains(paths, path) then
      table.insert(paths, path)
    end
  end

  cassette:close()

  table.sort(paths)

  return paths
end

local cassette_path_choices = function(cassette_name)
  local path_choices = {}

  for _, path in pairs(cassette_paths(cassette_name) or {}) do
    if v == path then
      return
    else
      table.insert(path_choices, t(path))
    end
  end

  return c(1, path_choices)
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
          return sn(nil, { cassette_path_choices(args[1][1]) })
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
}
