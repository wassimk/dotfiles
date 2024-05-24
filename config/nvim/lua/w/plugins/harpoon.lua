--
-- harpoon
-- https://github.com/ThePrimeagen/harpoon
--

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  config = true,
  keys = {
    {
      '<leader>hh',
      function()
        require('harpoon'):list():add()
      end,
      desc = 'HARPOON: mark',
    },
    {
      '<c-e>',
      function()
        local harpoon = require('harpoon')

        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'HARPOON: toggle UI',
    },
    {
      '<M-r>1',
      function()
        require('harpoon'):list():select(1)
      end,
      desc = 'HARPOON: go to file 1',
    },
    {
      '<M-r>2',
      function()
        require('harpoon'):list():select(2)
      end,
      desc = 'HARPOON: go to file 2',
    },
    {
      '<M-r>3',
      function()
        require('harpoon'):list():select(3)
      end,
      desc = 'HARPOON: go to file 3',
    },
    {
      '<M-r>4',
      function()
        require('harpoon'):list():select(4)
      end,
      desc = 'HARPOON: go to file 4',
    },
  },
}
