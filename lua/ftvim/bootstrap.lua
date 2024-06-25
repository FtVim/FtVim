vim.api.nvim_echo({
  { "FtVim requires Neovim >= 0.9.0\n", "ErrorMsg" },
  { "Press any key to exit", "MoreMsg" },
}, true, {})
vim.fn.getchar()
vim.cmd([[quit]])
return {}
