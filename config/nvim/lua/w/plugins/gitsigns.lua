--
-- gitsigns.nvim
-- https://github.com/lewis6991/gitsigns.nvim
--

return {
  'lewis6991/gitsigns.nvim',
  version = '*',
  config = function()
    require('gitsigns').setup({
      sign_priority = 6, -- higher than todo-comments
      trouble = false, -- don't load trouble.nvim for the setqflist and setloclist feature
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function keymap(mode, l, r, opts)
          opts.buffer = bufnr
          opts.desc = 'GITSIGNS: ' .. opts.desc
          vim.keymap.set(mode, l, r, opts)
        end

        -- navigation
        keymap('n', ']h', function()
          if vim.wo.diff then
            return ']h'
          end

          vim.schedule(function()
            gs.next_hunk()
          end)

          return '<Ignore>'
        end, { expr = true, desc = 'goto next hunk' })

        keymap('n', '[h', function()
          if vim.wo.diff then
            return '[h'
          end

          vim.schedule(function()
            gs.prev_hunk()
          end)

          return '<Ignore>'
        end, { expr = true, desc = 'goto previous hunk' })

        -- actions
        keymap({ 'n', 'v' }, '<leader>hs', gs.stage_hunk, { desc = 'stage hunk' })
        keymap({ 'n', 'v' }, '<leader>hr', gs.reset_hunk, { desc = 'reset hunk' })
        keymap('n', '<leader>hS', gs.stage_buffer, { desc = 'stage buffer' })
        keymap('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
        keymap('n', '<leader>hR', gs.reset_buffer, { desc = 'reset buffer' })
        keymap('n', '<leader>hp', gs.preview_hunk, { desc = 'preview hunk' })
        keymap('n', '<leader>hb', function()
          gs.blame_line({ full = true })
        end, { desc = 'blame line' })
        keymap('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle current line blame' })
        keymap('n', '<leader>hd', gs.diffthis, { desc = 'diff this' })
        keymap('n', '<leader>hD', function()
          gs.diffthis('~')
        end, { desc = 'diff this (other)' })
        keymap('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle deleted' })

        -- text object
        keymap({ 'o', 'x' }, 'ih', gs.select_hunk, { desc = 'select hunk' })
      end,
    })
  end,
}
