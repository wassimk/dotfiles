-- custom nvim-cmp source for Ruby on Rails fixture names with inline documentation

local rails_fixture_names = {}

local registered = false

rails_fixture_names.setup = function()
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
    vim.notify('Need the plenary plugin installed for cmp-rails-fixture-names to work')
    return
  end

  local success, types = pcall(function()
    local fixtures_dir = './test/fixtures'

    local files = scan.scan_dir(fixtures_dir, { search_pattern = '.yml', respect_gitignore = true,
      silent = true })

    local types = {}
    for _, file in ipairs(files) do
      local type = file:match(fixtures_dir .. '/(.+)%.yml$')
      types[type:gsub('/', '_')] = file
    end

    return types
  end)
  if not success then
    return
  end

  local valid_type = function(type)
    if type == nil or type == '' then
      return false
    end

    return types[type] ~= nil
  end

  local names = function(type)
    local filename = types[type]
    local file = io.open(filename, 'r')

    local names = {}

    for line in file:lines() do
      local name = line:match('^([a-z_]+):')
      if name then
        table.insert(names, name)
      end
    end

    io.close(file)

    return names
  end

  local name_documentation = function(type, name)
    local filename = types[type]
    local file = io.open(filename, 'r')

    local documentation = ''
    local matched = false

    for line in file:lines() do
      if not matched then
        matched = line:match('^' .. name .. ':')
        if matched then
          documentation = name .. ':\n'
        end
      else
        if (line == nil) or (line == '') then
          matched = false
        else
          documentation = documentation .. line .. '\n'
        end
      end
    end

    io.close(file)

    return documentation
  end

  local source = {}

  source.new = function()
    return setmetatable({}, { __index = source })
  end

  source.is_available = function()
    local current_buffer_path = vim.fn.expand('%')

    return vim.startswith(current_buffer_path, 'test/')
  end

  source.get_trigger_characters = function()
    return { ':' }
  end

  source.complete = function(_, request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset - 1)
    local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)

    local type = prefix:match('(%g+)%(%:$')

    if vim.startswith(input, ':') and valid_type(type) then
      local items = {}
      for _, name in ipairs(names(type)) do
        local cmp_item = {
          filterText = name,
          label = name,
          documentation = name_documentation(type, name),
          textEdit = {
            newText = ':' .. name,
            range = {
              start = {
                line = request.context.cursor.row - 1,
                character = request.context.cursor.col - 1 - #input,
              },
              ['end'] = {
                line = request.context.cursor.row - 1,
                character = request.context.cursor.col - 1,
              },
            },
          },
        }

        table.insert(items, cmp_item)
      end
      callback {
        items = items,
        isIncomplete = true,
      }
    else
      callback { isIncomplete = true }
    end
  end

  cmp.register_source('rails_fixture_names', source.new())
end

return rails_fixture_names
