local M = {}

function M.setup()
  -- remap leader and local leader to <Space>
  -- here because lazy.nvim wants this to happen first
  vim.api.nvim_set_keymap('', '<Space>', '<Nop>', {})
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- vim style plugin configs before they load
  vim.keymap.set({ 'n', 'c' }, '<C-f>', '', { desc = 'unmap neovim default for telescope' })
  vim.g.tmux_navigator_no_mappings = 1

  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)

  local configuration = {
    dev = {
      path = '~/Personal/neovim',
    },
    checker = {
      enabled = false, -- auto-updates
      notify = false,
      frequency = 3600 * 24,
    },
    change_detection = {
      notify = false,
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          'matchparen',
          'netrw',
          'netrwPlugin',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
        },
      },
    },
  }

  require('lazy').setup('w.plugins', configuration)
end

return M
