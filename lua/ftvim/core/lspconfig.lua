local M = {}

M.config = function()
	ftvim.builtin.lspconfig = {
		active = true,
		servers = {
			lua_ls = {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			},
			clangd = {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			},
		},
	}
end

M.setup = function()
	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		print("Error loading nvim-lspconfig")
		return
	end

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	for server, config in pairs(ftvim.builtin.lspconfig.servers) do
		config.capabilities = capabilities
		lspconfig[server].setup(config)
	end

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
	
	if ftvim.builtin.lspconfig.on_config_done then
		ftvim.builtin.lspconfig.on_config_done()
	end
end

return M
