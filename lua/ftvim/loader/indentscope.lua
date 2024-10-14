local M = {}

M.config = {
	opts = {
		symbol = "▏",
		options = { try_as_border = true },
	},
	disable_filetypes = {
		"help",
		"alpha",
		"dashboard",
		"neo-tree",
		"Trouble",
		"trouble",
		"lazy",
		"mason",
		"notify",
		"toggleterm",
		"lazyterm",
	},
}

M.setup = function()
	local status_ok, indentscope = pcall(require, "mini.indentscope")
	if not status_ok then
		print("Error loading mini.indentscope")
		return
	end

	indentscope.setup(M.config.opts)

	vim.api.nvim_create_autocmd("FileType", {
		pattern = M.config.disable_filetypes,
		callback = function()
			vim.b.miniindentscope_disable = true
		end,
	})
end

return M
