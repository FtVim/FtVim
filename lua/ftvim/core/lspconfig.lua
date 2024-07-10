local M = {}

M.setup = function()
	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if not status_ok then
		return
	end

	M.capabilities = cmp_nvim_lsp.default_capabilities()
end

M.config = function()
	local status_ok, lspconfig = pcall(require, "lspconfig")
	if not status_ok then
		print("Failed to load lspconfig")
		return
	end

	if not M.capabilities then
		M.setup()
	end

	lspconfig.lua_ls.setup({
		capabilities = M.capabilities,
	})

	lspconfig.clangd.setup({
		capabilities = M.capabilities,
	})

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
end

return M
