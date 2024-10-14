local M = {}

M.setup = function()
	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		print("Failed to load lspconfig")
		return
	end
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	require("neodev").setup()
	local lsp_available = function(server_name)
		local server_available, server = lspconfig.util.available_servers(server_name)
		return server_available
	end

	if lsp_available("lua_ls") then
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			filetypes = { "lua" }
		})
	end

	if lsp_available("clangd") then
		lspconfig.clangd.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			cmd = {
				"clangd",
				"--offset-encoding=utf-16",
			},
			autostart = false,
			filetypes = { "c", "cpp" }
		})
	end
	if lsp_available("pyright") then
		lspconfig.pyright.setup({
			capabilities = capabilities,
			filetypes = { "python" }
		})
	end
	if lsp_available("ts_ls") then
		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript" }
		})
	end

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
end

return M
