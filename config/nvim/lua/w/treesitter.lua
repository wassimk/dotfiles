--
-- treesitter
--
-- Uses the nvim-treesitter main branch purely as a parser/query
-- installer. Highlighting and folding come from built-in Neovim;
-- indent comes from nvim-treesitter's experimental indentexpr.
--

local parsers = {
  'bash',
  'c',
  'comment',
  'css',
  'dockerfile',
  'go',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'regex',
  'ruby',
  'rust',
  'scheme',
  'scss',
  'sql',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'yaml',
}

-- run `fn` at most once per `hours`, tracked via a timestamp file
local function debounced(hours, marker, fn)
  local path = vim.fn.stdpath('data') .. '/' .. marker
  local f = io.open(path, 'r')
  local last = f and tonumber(f:read()) or 0
  if f then
    f:close()
  end
  if os.time() - last < hours * 3600 then
    return
  end
  local w = assert(io.open(path, 'w+'))
  w:write(os.time())
  w:close()
  fn()
end

local ok, ts = pcall(require, 'nvim-treesitter')
if ok then
  ts.install(parsers)
  debounced(24 * 7, 'nvim-treesitter-update-debounce', function()
    ts.update()
  end)
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local buf = args.buf
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    if lang and pcall(vim.treesitter.start, buf, lang) then
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevelstart = 99
