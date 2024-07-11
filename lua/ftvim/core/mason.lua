local M = {}

M.config = function()
	ftvim.builtin.mason = {
		active = true,
		-- ensure_installed = {
		-- 	"clangd",
		-- 	"lua_ls", -- Remove later if necessary
		-- },
	}
end

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

	mason.setup()

	mason_lspconfig.setup({
		ensure_installed = ftvim.builtin.mason.ensure_installed,
	})

	if ftvim.builtin.mason.on_config_done then
		ftvim.builtin.mason.on_config_done()
	end
end

return M
