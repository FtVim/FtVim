local M = {}

M.config = {
	enable = true,
	opts = {},
	-- stylua: ignore
	keys = {
		{ "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
		{ "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
		{ "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
	},
}

M.setup = function()
	local status_ok, persistence = pcall(require, "persistence")
	if not status_ok then
		print("Error loading persistence.nvim")
		return
	end

	persistence.setup(M.config)
end

return M
