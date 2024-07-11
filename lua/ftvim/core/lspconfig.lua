local M = {}

M.config = function()
	ftvim.builtin.lspconfig = {
		active = true
	}

	local capabilities = require('cmp_nvim_lsp').default_capabilities()
	local lspconfig = require("lspconfig")
	local lsp_available = function(server_name)
		local servers = require("mason-lspconfig").get_installed_servers()
		for _, name in ipairs(servers) do
			if name == server_name then
				return true
			end
		end
		return false
	end

	if lsp_available("lua_ls") then
		lspconfig.lua_ls.setup({
			capabilities = capabilities
		})
	end

	if lsp_available("clangd") then
		lspconfig.clangd.setup({
			capabilities = capabilities
		})
	end

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
end

M.setup = function()
	local status_lsp_ok, lspconfig = pcall(require, "lspconfig")
	if not status_lsp_ok then
		print("Error loading lspconfig")
		return
	end

	if ftvim.builtin.lspconfig.active then
		M.config()
	end

	if ftvim.builtin.mason.on_config_done then
		ftvim.builtin.mason.on_config_done()
	end
end

return M

