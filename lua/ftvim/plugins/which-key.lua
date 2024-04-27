
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
      function ()
        local wk = require("which-key")
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
          },
        }
        , { prefix = "<leader>" })
    end,
  },
}
