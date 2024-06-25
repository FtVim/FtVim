return {
	"akinsho/toggleterm.nvim",
	branch = "main",
	init = function()
		require("ftvim.core.terminal").init()
	end,
	config = function()
		require("ftvim.core.terminal").setup()
	end,
	cmd = {
		"ToggleTerm",
		"TermExec",
		"ToggleTermToggleAll",
		"ToggleTermSendCurrentLine",
		"ToggleTermSendVisualLines",
		"ToggleTermSendVisualSelection",
	},
	keys = ftvim.builtin.terminal.open_mapping,
	enabled = ftvim.builtin.terminal.active,
}
