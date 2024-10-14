local M = {}

M.config = {
	completion = {
		completeopt = "menu,menuone,preview,noselect",
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-k>"] = "select_prev_item", -- previous suggestion
		["<C-j>"] = "select_next_item", -- next suggestion
		["<C-b>"] = "scroll_docs(-4)",
		["<C-f>"] = "scroll_docs(4)",
		["<C-Space>"] = "complete", -- show completion suggestions
		["<C-e>"] = "abort", -- close completion window
		["<CR>"] = "confirm({ select = true })",
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "copilot" }, -- copilot
		{ name = "luasnip" }, -- snippets
		{ name = "buffer" }, -- text within current buffer
		{ name = "path" }, -- file system paths
	},
	formatting = {
		format = function(entry, vim_item)
			local lspkind = require("lspkind")
			return lspkind.cmp_format({
				maxwidth = 50,
				ellipsis_char = "...",
				symbol_map = { Copilot = "" },
			})(entry, vim_item)
		end,
	},
}

M.setup = function()
	local status_ok, cmp = pcall(require, "cmp")
	if not status_ok then
		print("Error loading nvim-cmp")
		return
	end

	local luasnip = require("luasnip")
	local lspkind = require("lspkind")

	cmp.setup({
		completion = M.config.completion,
		snippet = {
			expand = M.config.snippet.expand,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-k>"] = cmp.mapping.select_prev_item(),
			["<C-j>"] = cmp.mapping.select_next_item(),
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
		}),
		sources = M.config.sources,
		formatting = {
			format = M.config.formatting.format,
		},
	})
end

return M
