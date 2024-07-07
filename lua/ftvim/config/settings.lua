local M = {}

M.load_defaults = function()
	local default_options = {
		number = true, -- Make line numbers default
		relativenumber = true, -- Add relative line numbers, to help with jumping.
		mouse = "a", -- Enable mouse mode
		showmode = false, -- Don't show the mode
		clipboard = "unnamedplus", -- Sync clipboard between OS and Neovim.
		breakindent = true, -- Enable break indent
		undofile = true, -- Save undo history
		ignorecase = true, -- Case-insensitive
		smartcase = true, -- Smart-case
		splitright = true, -- Configure how new splits should be opened
		splitbelow = true, -- Configure how new splits should be opened
		cursorline = false, -- Dont Show which line your cursor is on
		tabstop = 4, -- tabs & indentation
		shiftwidth = 4, -- tabs & indentation
		autoindent = true, -- tabs & indentation
	}

	---  SETTINGS  ---
	vim.opt.spelllang:append("cjk") -- disable spellchecking for asian characters (VIM algorithm does not support it)
	vim.opt.shortmess:append("c") -- don't show redundant messages from ins-completion-menu
	vim.opt.shortmess:append("I") -- don't show the default intro message
	vim.opt.whichwrap:append("<,>,[,],h,l")
	if vim.fn.has("nvim-0.10.0") == true then
		vim.o.expandtab = false -- tabs & indentation
	elseif vim.fn.has("nvim-0.9.5") == true then
		vim.o.noexpandtab = true -- tabs & indentation
	end

	for k, v in pairs(default_options) do
		vim.opt[k] = v
	end
end

return M
