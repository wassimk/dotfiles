--
-- gitsigns.nvim
-- https://github.com/lewis6991/gitsigns.nvim
--

require('gitsigns').setup({
  sign_priority = 6, -- higher than todo-comments
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function keymap(mode, l, r, opts)
      opts = opts or { noremap = true, silent = true }
      opts.buffer = bufnr
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
    end, { expr = true })

    keymap('n', '[h', function()
      if vim.wo.diff then
        return '[h'
      end

      vim.schedule(function()
        gs.prev_hunk()
      end)

      return '<Ignore>'
    end, { expr = true })

    -- actions
    keymap({ 'n', 'v' }, '<leader>hs', gs.stage_hunk)
    keymap({ 'n', 'v' }, '<leader>hr', gs.reset_hunk)
    keymap('n', '<leader>hS', gs.stage_buffer)
    keymap('n', '<leader>hu', gs.undo_stage_hunk)
    keymap('n', '<leader>hR', gs.reset_buffer)
    keymap('n', '<leader>hp', gs.preview_hunk)
    keymap('n', '<leader>hb', function()
      gs.blame_line({ full = true })
    end)
    keymap('n', '<leader>tb', gs.toggle_current_line_blame)
    keymap('n', '<leader>hd', gs.diffthis)
    keymap('n', '<leader>hD', function()
      gs.diffthis('~')
    end)
    keymap('n', '<leader>td', gs.toggle_deleted)

    -- text object
    keymap({ 'o', 'x' }, 'ih', gs.select_hunk)
  end,
})
