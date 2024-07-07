local M = {}

M.config = function()
	ftvim.builtin.persistence = {
		enable = true,
		options = {
			dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
			vim.opt.sessionoptions:get(),
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
