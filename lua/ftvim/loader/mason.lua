local M = {}

M.config = {
		active = true,
		ensure_installed = {
			"clangd",
			"lua_ls", -- Remove later if necessary
		},
	}

M.setup = function()
	local status_mason_ok, mason = pcall(require, "mason")
	if not status_mason_ok then
		print("Error loading mason.nvim")
		return
	end

	local status_mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not status_mason_lspconfig_ok then
		print("Error loading mason-lspconfig.nvim")
		return
	end

	mason.setup(M.config)
end

return M
