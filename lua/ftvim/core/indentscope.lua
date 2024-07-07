local M = {}

M.config = function()
	ftvim.builtin.indentscope = {
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
end

M.setup = function()
	local status_ok, indentscope = pcall(require, "mini.indentscope")
	if not status_ok then
		print("Error loading mini.indentscope")
		return
	end

	indentscope.setup(ftvim.builtin.indentscope.opts)

	vim.api.nvim_create_autocmd("FileType", {
		pattern = ftvim.builtin.indentscope.disable_filetypes,
		callback = function()
			vim.b.miniindentscope_disable = true
		end,
	})

	if ftvim.builtin.indentscope.on_config_done then
		ftvim.builtin.indentscope.on_config_done()
	end
end

return M
