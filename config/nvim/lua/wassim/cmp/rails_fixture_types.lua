-- custom nvim-cmp source for Ruby on Rails fixture types

local rails_fixture_types = {}

local registered = false

rails_fixture_types.setup = function()
  if registered then
    return
  end
  registered = true

  local has_cmp, cmp = pcall(require, 'cmp')
  if not has_cmp then
    return
  end

  local has_scan, scan = pcall(require, 'plenary.scandir')
  if not has_scan then
    vim.notify('Need the plenary plugin installed for cmp-rails-fixture-types to work')
    return
  end


  local success, types = pcall(function()
    local fixtures_dir = './test/fixtures'

    local files = scan.scan_dir(fixtures_dir, { search_pattern = '.yml', respect_gitignore = true,
      silent = true })

    local types = {}
    for _, file in ipairs(files) do
      local type = file:match(fixtures_dir .. '/(.+)%.yml$')
      type = type:gsub('/', '_')

      table.insert(types, type)
    end

    return types
  end)
  if not success then
    return
  end

  local source = {}

  source.new = function()
    return setmetatable({}, { __index = source })
  end

  source.is_available = function()
    local current_buffer_path = vim.fn.expand('%')

    return vim.startswith(current_buffer_path, 'test/')
  end

  source.complete = function(_, request, callback)
    local results = {}

    for _, type in ipairs(types) do
      local cmp_item = {
        label = type,
        word = type .. '(',
      }
      table.insert(results, cmp_item)
    end

    callback(results)
  end

  cmp.register_source('rails_fixture_types', source.new())
end

return rails_fixture_types
