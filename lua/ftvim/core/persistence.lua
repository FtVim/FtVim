local M = {}

M.config = function()
	ftvim.builtin.persistence = {
		enable = true,
		options = vim.opt.sessionoptions:get(),
		-- stylua: ignore
		keys = {
			{ "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
			{ "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
			{ "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
		},
	}
end

M.setup = function()
	local status_ok, persistence = pcall(require, "persistence")
	if not status_ok then
		print("Error loading persistence.nvim")
		return
	end

	persistence.setup(ftvim.builtin.persistence.options)
	

	if ftvim.builtin.persistence.on_config_done then
		ftvim.builtin.persistence.on_config_done()
	end
end

return M
