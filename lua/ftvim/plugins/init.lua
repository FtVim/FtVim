if vim.fn.has("nvim-0.9.0") == 0 then
	vim.api.nvim_echo({
		{ "FtVim requires Neovim >= 0.9.0\n", "ErrorMsg" },
		{ "Press any key to exit", "MoreMsg" },
	}, true, {})
	vim.fn.getchar()
	vim.cmd([[quit]])
	return {}
end

local plugins = {
	-- tokyonight
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("onedark")
		end,
		opts = {
			style = "moon",
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
	},
}

return plugins
