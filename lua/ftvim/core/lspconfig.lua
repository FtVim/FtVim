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
	local lspconfig = require("lspconfig")

	for server, config in pairs(ftvim.builtin.lspconfig.servers) do
		lspconfig[server].setup(config)
	end

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})

	if ftvim.builtin.lspconfig.on_config_done then
		ftvim.builtin.lspconfig.on_config_done()
	end
end

return M
