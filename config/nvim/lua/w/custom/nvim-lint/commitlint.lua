--
-- commitlint json parser for nvim-lint
-- https://commitlint.js.org/#/
-- https://www.npmjs.com/package/commitlint-format-json
-- commitlint is built into nvim-lint but it never worked for me
-- the commitlint binary and the json parser are both installed via :Mason
--

local M = {}

local function getDiagnosticDetails(details)
  local diagnostic = {
    severity = details.level,
    message = details.message,
    source = details.name,
    lnum = 0, -- default value
    col = 0, -- we don't get column numbers
  }

  if details.name == 'body-leading-blank' then
    diagnostic.lnum = 2
  elseif vim.startswith(details.name, 'body') then
    diagnostic.lnum = 3
  end

  return diagnostic
end

local function transform_json_to_diagnostics(output)
  local json = vim.fn.json_decode(output)
  local diagnostics = {}

  for _, result in ipairs(json.results) do
    for _, error in ipairs(result.errors) do
      local diagnostic = getDiagnosticDetails(error)

      table.insert(diagnostics, diagnostic)
    end

    for _, warning in ipairs(result.warnings) do
      local diagnostic = getDiagnosticDetails(warning)

      table.insert(diagnostics, diagnostic)
    end
  end

  return diagnostics
end

function M.setup(configFile)
  local args = {
    '--format',
    'commitlint-format-json',
  }

  if configFile and #configFile > 0 then
    table.insert(args, '--config')
    table.insert(args, configFile)
  end

  require('lint').linters.commitlint = {
    cmd = 'commitlint',
    stdin = true,
    ignore_exitcode = true,
    args = args,
    parser = transform_json_to_diagnostics,
  }
end

return M
