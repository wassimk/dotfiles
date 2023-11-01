--
-- nvim-lint
-- https://github.com/mfussenegger/nvim-lint
--

return {
  'mfussenegger/nvim-lint',
  config = function()
    local utils = require('w.utils')

    local luaLinters = { 'codespell' }
    if utils.config_exists('selene.toml') then
      table.insert(luaLinters, 'selene')
    end

    if utils.config_exists('.luacheckrc') then
      table.insert(luaLinters, 'luacheck')
    end

    local javascriptLinters = { 'codespell' }

    require('lint').linters_by_ft = {
      ruby = { 'codespell' },
      javascript = javascriptLinters,
      javascriptreact = javascriptLinters,
      typescript = javascriptLinters,
      typescriptreact = javascriptLinters,
      lua = luaLinters,
    }
  end,
}
