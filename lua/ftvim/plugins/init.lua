vim.api.nvim_out_write("hello out write\n")
vim.notify("Hello Notify")

require("ftvim.bootstrap"):init()

return {
  { "folke/lazy.nvim", version = "*" },
  { "FtVim/FtVim", priority = 10000, lazy = false, opts = {}, cond = true, version = "*" },
}
