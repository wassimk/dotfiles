--
-- harpoon
-- https://github.com/ThePrimeagen/harpoon
--

return {
  'ThePrimeagen/harpoon',
  keys = {
    {
      '<leader>h',
      function()
        require('harpoon.mark').add_file()
      end,
      desc = 'HARPOON: mark',
    },
    {
      '<c-e>',
      function()
        require('harpoon.ui').toggle_quick_menu()
      end,
      desc = 'HARPOON: toggle UI',
    },
    {
      '<M-r>1',
      function()
        require('harpoon.ui').nav_file(1)
      end,
      desc = 'HARPOON: go to file 1',
    },
    {
      '<M-r>2',
      function()
        require('harpoon.ui').nav_file(2)
      end,
      desc = 'HARPOON: go to file 2',
    },
    {
      '<M-r>3',
      function()
        require('harpoon.ui').nav_file(3)
      end,
      desc = 'HARPOON: go to file 3',
    },
    {
      '<M-r>4',
      function()
        require('harpoon.ui').nav_file(4)
      end,
      desc = 'HARPOON: go to file 4',
    },
  },
}
