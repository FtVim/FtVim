return {
	-- Treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			require'nvim-treesitter.configs'.setup {
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
				sync_install = false,
				highlight = {
					enable = true,
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					additional_vim_regex_highlighting = false,
				},
			}
		end
	},
	-- terminal
	{

		"akinsho/toggleterm.nvim",

		branch = "main",

		init = function()
			require("ftvim.loader.terminal").init()
		end,

		config = function()
			require("ftvim.loader.terminal").setup()
		end,

		cmd = {

			"ToggleTerm",

			"TermExec",

			"ToggleTermToggleAll",

			"ToggleTermSendCurrentLine",

			"ToggleTermSendVisualLines",

			"ToggleTermSendVisualSelection",
		},

		keys = [[<c-\>]],

	},
	{
		's1n7ax/nvim-window-picker',
		version = '2.*',
		config = function()
			require 'window-picker'.setup({
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						filetype = { 'neo-tree', "neo-tree-popup", "notify" },
						-- if the buffer type is one of following, the window will be ignored
						buftype = { 'terminal', "quickfix" },
					},
				},
			})
		end,
	},
	-- file explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		config = function()
			require("ftvim.loader.neo-tree").setup()
		end,
	},
	-- Keymaps hints
	{
		"folke/which-key.nvim",
		event = "BufEnter",
		opts = {},
		config = function()
			require("ftvim.loader.which-key").setup()
		end,
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
			{
				"<c-w><space>",
				function()
					require("which-key").show({ keys = "<c-w>", loop = true })
				end,
				desc = "Window Hydra Mode (which-key)",
			},
		},
	},

	-- Motions
	{
		'echasnovski/mini.ai',
		version = false,
		config = function()
			require("mini.ai").setup()
		end
	},
	{
		"echasnovski/mini.bufremove",

		branch = "main",

		config = function()
			require("ftvim.loader.mini_bufremove").setup()
		end,
	},

}
