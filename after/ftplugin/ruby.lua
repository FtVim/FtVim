-- Ruby filetype settings (paridad con ~/.config/nvim)
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.expandtab = true
vim.bo.smartindent = true

vim.keymap.set("n", "<leader>rr", ":!ruby %<CR>", { buffer = true, desc = "Run Ruby file" })
