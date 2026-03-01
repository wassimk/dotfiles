--
-- mini.ai + mini.extra
-- https://github.com/echasnovski/mini.ai
-- https://github.com/echasnovski/mini.extra
--

return {
  {
    'echasnovski/mini.ai',
    dependencies = 'echasnovski/mini.extra',
    config = function()
      local gen_ai_spec = require('mini.extra').gen_ai_spec

      require('mini.ai').setup({
        mappings = {
          around_last = 'aL',
          inside_last = 'iL',
        },
        custom_textobjects = {
          B = gen_ai_spec.buffer(),
          I = gen_ai_spec.indent(),
          l = gen_ai_spec.line(),
          N = gen_ai_spec.number(),
          D = gen_ai_spec.diagnostic(),
        },
      })
    end,
  },
}
