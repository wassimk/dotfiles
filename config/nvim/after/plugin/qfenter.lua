--
-- QFEnter
-- https://github.com/yssl/QFEnter
--

if packer_plugins['wfenter'] and packer_plugins['qfenter'].loaded then
  vim.g.qfenter_keymap = {
    vopen = { '<C-v>' },
    hopen = { '<C-x>' },
    topen = { '<C-t>' },
  }
end
