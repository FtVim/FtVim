-- FtVim Options
-- These are loaded before plugins

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

-- Clipboard
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- UI
opt.cursorline = false
opt.laststatus = 3
opt.number = true
opt.relativenumber = true
opt.pumblend = 10
opt.pumheight = 10
opt.scrolloff = 4
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.termguicolors = true
opt.winminwidth = 5

-- Indentation
opt.expandtab = false
opt.shiftround = true
opt.shiftwidth = 4
opt.smartindent = true
opt.tabstop = 4
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Folding
opt.foldlevel = 99

-- Format
opt.formatoptions = "jcroqlnt"

-- Wrapping
opt.linebreak = true
opt.wrap = false

-- Windows
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true

-- Session
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

-- Misc
opt.jumpoptions = "view"
opt.mouse = "a"
opt.timeoutlen = vim.g.vscode and 1000 or 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"

-- Spelling
opt.spelllang = { "en" }
opt.spelloptions:append("noplainbuffer")
opt.spelllang:append("cjk")

-- Shortmess
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Whichwrap
opt.whichwrap:append("<,>,[,],h,l")
