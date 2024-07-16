local M = {}

M.setup = function()
	local ok, copilot = pcall(require, "copilot")
	if not ok then
		return
	end

	copilot.setup()
	copilot.setup {
		suggestion = {
			keymap = {
				accept = "",
				next = "",
				prev = "",
				dismiss = "",
			},
		},
	}

	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", "", "lua require('copilot.suggestion').toggle_auto_trigger()", opts)

	if ftvim.builtin.copilot_cmp.on_config_done then
		ftvim.builtin.copilot_cmp.on_config_done()
	end
end

return M
