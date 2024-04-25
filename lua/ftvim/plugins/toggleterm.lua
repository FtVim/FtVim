return {
  "akinsho/toggleterm.nvim",
  event = "VeryLazy",
  config = function()
    require("toggleterm").setup()

    local Terminal = require("toggleterm.terminal").Terminal
    local colors = require("config.colors").colors
    local defaults = {
      direction = "float",
      float_opts = {
        border = "single",
      },
      shade_terminals = false,
      highlights = {
        Normal = {
          guibg = colors.grey14,
        },
        FloatBorder = {
          guibg = colors.grey14,
          guifg = colors.grey14,
        },
      },
    }
  end,
}
