--
-- markdown filetype
--

vim.o.spell = true

pcall(function()
  require('wrapping').soft_wrap_mode()
end)
