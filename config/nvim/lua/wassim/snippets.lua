local snippy = require("snippy")

snippy.setup({
  scopes = {
    ruby = { '_', 'ruby', 'rails' },
  },
  mappings = {
    is = {
      ["<Tab>"] = "expand_or_advance",
      ["<S-Tab>"] = "previous",
    },
    nx = {
      ["<leader>x"] = "cut_text",
    },
  },
})
