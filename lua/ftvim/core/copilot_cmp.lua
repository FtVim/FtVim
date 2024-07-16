local M = {}

M.config = function()
	ftvim.builtin.copilot_cmp = {
		setup = {
			suggestion = {
				keymap = {
					accept = "",
					next = "",
					prev = "",
					dismiss = "",
				},
			},
		},
	}
end

M.setup = function()
	local ok, copilot = pcall(require, "copilot")
	if not ok then
		print("copilot not loaded")
		return
	end

	copilot.config(ftvim.builtin.copilot_cmp.setup)

	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", "", "lua require('copilot.suggestion').toggle_auto_trigger()", opts)

	if ftvim.builtin.copilot_cmp.on_config_done then
		ftvim.builtin.copilot_cmp.on_config_done()
	end
end

return M
