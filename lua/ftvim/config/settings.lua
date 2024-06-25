local M = {}

M.load_defaults = function()
	local default_options = {
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
	}

	---  SETTINGS  ---
	vim.opt.spelllang:append "cjk" -- disable spellchecking for asian characters (VIM algorithm does not support it)
	vim.opt.shortmess:append "c" -- don't show redundant messages from ins-completion-menu
	vim.opt.shortmess:append "I" -- don't show the default intro message
	vim.opt.whichwrap:append "<,>,[,],h,l"

	for k, v in pairs(default_options) do
		vim.opt[k] = v
	end

	vim.filetype.add {
		extension = {
			tex = "tex",
			zir = "zir",
			cr = "crystal",
		},
		pattern = {
			["[jt]sconfig.*.json"] = "jsonc",
		},
	}
end

return M
