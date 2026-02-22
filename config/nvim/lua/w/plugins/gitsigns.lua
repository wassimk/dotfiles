--
-- gitsigns.nvim
-- https://github.com/lewis6991/gitsigns.nvim
--

return {
  'lewis6991/gitsigns.nvim',
  version = '*',
  event = 'BufRead',
  opts = {
    sign_priority = 6, -- higher than todo-comments
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts.buffer = bufnr
        opts.desc = opts.desc
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', '<leader>hn', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = 'jump to next hunk' })

      map('n', '<leader>hp', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = 'jump to previous hunk' })

      -- Actions
      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'stage hunk' })
      map('n', '<leader>hS', gitsigns.undo_stage_hunk, { desc = 'undo stage hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'reset hunk' })
      map('v', '<leader>hs', function()
        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'stage hunk' })
      map('v', '<leader>hr', function()
        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'reset hunk' })
      map('n', '<leader>hb', gitsigns.stage_buffer, { desc = 'stage buffer' })
      map('n', '<leader>hB', gitsigns.reset_buffer_index, { desc = 'undo stage buffer' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'reset buffer' })
      map('n', '<leader>hf', function()
        gitsigns.blame_line({ full = true })
      end, { desc = 'blame line float' })
      map('n', '<leader>hF', gitsigns.toggle_current_line_blame, { desc = 'toggle current line blame' })
      map('n', '<leader>hdt', gitsigns.diffthis, { desc = 'diff this' })
      map('n', '<leader>hdo', function()
        gitsigns.diffthis('~')
      end, { desc = 'diff this (other)' })
      map('n', '<leader>ht', gitsigns.toggle_deleted, { desc = 'toggle deleted' })
      map('n', '<leader>hi', gitsigns.preview_hunk, { desc = 'preview hunk float' })
      map('n', '<leader>hI', gitsigns.preview_hunk_inline, { desc = 'preview hunk inline' })
      map('n', '<leader>hl', function()
        gitsigns.setloclist()
      end, { desc = 'hunks to loclist' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select hunk' })
    end,
  },
}
