-- [[ Setting options ]]
local opt = vim.opt

-- Make line numbers default
opt.number = true
-- Add relative line numbers, to help with jumping.
opt.relativenumber = true

-- Enable mouse mode
opt.mouse = "a"

-- Don't show the mode
opt.showmode = false

-- Sync clipboard between OS and Neovim.
opt.clipboard = "unnamedplus"

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Case-insensitive
opt.ignorecase = true
opt.smartcase = true

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Dont Show which line your cursor is on
opt.cursorline = false

-- tabs & indentation
vim.o.noexpandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.autoindent = true
