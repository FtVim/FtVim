local M = {}

M.config = function()
	ftvim.builtin.indentlines = {
		active = true,
		on_config_done = nil,
		options = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = { enabled = false },
			exclude = {
				filetypes = {
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
			},
		},
	}
end

M.setup = function()
	local status_ok, indent_blankline = pcall(require, "indent_blankline")
	if not status_ok then
		return
	end

	indent_blankline.setup(ftvim.builtin.indentlines.options)

	if ftvim.builtin.indentlines.on_config_done then
		ftvim.builtin.indentlines.on_config_done()
	end
end

return M
