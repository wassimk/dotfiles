function _G.qftf(info)
  local items
  local ret = {}
  -- The name of item in list is based on the directory of quickfix window.
  -- Change the directory for quickfix window make the name of item shorter.
  --
  -- local alterBufnr = vim.fn.bufname('#') -- alternative buffer is the buffer before enter qf window
  -- local root = getRootByAlterBufnr(alterBufnr)
  -- vim.cmd(('noa lcd %s'):format(vim.fn.fnameescape(root)))
  --
  if info.quickfix == 1 then
    items = vim.fn.getqflist({ id = info.id, items = 0 }).items
  else
    items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
  end

  local limit = 31
  local fnameFmt1, fnameFmt2 = '%-' .. limit .. 's', '…%.' .. (limit - 1) .. 's'
  local validFmt = '%s │%5d:%-3d│%s %s'
  local diagnostic_signs = require('w.diagnostic').signs(true)
  local lspkind_symbols = require('lspkind')

  local function decorate_diagnostic_sign(sign)
    return diagnostic_signs[sign] or sign
  end

  local function decorate_symbol(text)
    local symbol
    if text:find('^%[.*%]') then
      local symbol_word = text:match('^%[(.*)%]')

      symbol = lspkind_symbols.symbolic(symbol_word, { mode = 'symbol', preset = 'codicons' })
      if symbol == '' then
        symbol = ' '
      end
    end

    return symbol .. ' ' .. text
  end

  for i = info.start_idx, info.end_idx do
    local e = items[i]
    local fname = ''
    local str

    if e.valid == 1 then
      if e.bufnr > 0 then
        fname = vim.fn.bufname(e.bufnr)
        if fname == '' then
          fname = '[No Name]'
        else
          fname = fname:gsub('^' .. vim.env.HOME, '~')
        end
        -- char in fname may occur more than 1 width, ignore this issue in order to keep performance
        if #fname <= limit then
          fname = fnameFmt1:format(fname)
        else
          fname = fnameFmt2:format(fname:sub(1 - limit))
        end
      end
      local lnum = e.lnum > 99999 and -1 or e.lnum
      local col = e.col > 999 and -1 or e.col

      local qtype = e.type
      local qtext = e.text
      if qtype ~= '' then
        qtype = ' ' .. decorate_diagnostic_sign(qtype)
      else
        qtext = decorate_symbol(qtext)
      end

      str = validFmt:format(fname, lnum, col, qtype, qtext)
    else
      str = e.text
    end
    table.insert(ret, str)
  end
  return ret
end

vim.o.qftf = '{info -> v:lua._G.qftf(info)}'
