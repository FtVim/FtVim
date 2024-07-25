local M = {}
local null_ls = require('null-ls')

M.config = function()
	ftvim.builtin.none = {
		active = true,
		sources = {
			-- Python shit
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.mypy,
			null_ls.builtins.formatting.ruff,
		},
		on_config_done = nil,
	}
end

M.setup = function()
	local status_ok, null_ls = pcall(require, "null-ls")
	if not status_ok then
		print("Error loading null-ls.nvim")
		return
	end

	local builtins = null_ls.builtins

	local sources = {}
	for _, source in ipairs(ftvim.builtin["null-ls"].sources) do
		local builtin_source = builtins.formatting[source] or builtins.diagnostics[source]
		if builtin_source then
			table.insert(sources, builtin_source)
		else
			print("Error: Source " .. source .. " not found in null-ls builtins")
		end
	end

	null_ls.setup({
		sources = sources,
	})

	if ftvim.builtin["null-ls"].on_config_done then
		ftvim.builtin["null-ls"].on_config_done()
	end
end

return M
