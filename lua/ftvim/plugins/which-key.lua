local wk = require("ftvim.plugins.which-key")

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
      wk.register({
      f = {
        name = "file", -- optional group name
      },
      b = {
          name = "buffer",
      },
      c = {
          name = "code",
      },
      q = {
          name = "quit",
      },
      s = {
          name = "search and replace",
      },
      t = {
          name = "term",
      },
      u = {
          name = "ui",
      },
      w = {
          name = "window",
      }
    }, { prefix = "<leader>" })
  },
}
