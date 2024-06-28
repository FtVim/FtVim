return {
	{ "folke/lazy.nvim", tag = "stable" },
	{

		"folke/tokyonight.nvim",

		lazy = not vim.startswith(ftvim.colorscheme, "tokyonight"),
	},

	-- Telescope

	{

		"nvim-telescope/telescope.nvim",

		branch = "0.1.x",

		config = function()
			require("ftvim.core.telescope").setup()
		end,

		dependencies = { "telescope-fzf-native.nvim" },

		lazy = true,

		cmd = "Telescope",

		enabled = ftvim.builtin.telescope.active,
	},

	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		lazy = true,
		enabled = ftvim.builtin.telescope.active,
	},

	-- Install nvim-cmp, and buffer source as a dependency

	{

		"hrsh7th/nvim-cmp",

		config = function()
			if ftvim.builtin.cmp then
				require("ftvim.core.cmp").setup()
			end
		end,

		event = { "InsertEnter", "CmdlineEnter" },

		dependencies = {

			"cmp-nvim-lsp",

			"cmp_luasnip",

			"cmp-buffer",

			"cmp-path",

			"cmp-cmdline",
		},
	},

	{ "hrsh7th/cmp-nvim-lsp", lazy = true },

	{ "saadparwaiz1/cmp_luasnip", lazy = true },

	{ "hrsh7th/cmp-buffer", lazy = true },

	{ "hrsh7th/cmp-path", lazy = true },

	{

		"hrsh7th/cmp-cmdline",

		lazy = true,

		enabled = ftvim.builtin.cmp and ftvim.builtin.cmp.cmdline.enable or false,
	},

	-- Autopairs

	{

		"windwp/nvim-autopairs",

		event = "InsertEnter",

		config = function()
			require("ftvim.core.autopairs").setup()
		end,

		enabled = ftvim.builtin.autopairs.active,

		dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
	},

	-- Treesitter

	{

		"nvim-treesitter/nvim-treesitter",

		-- run = ":TSUpdate",

		config = function()
			local utils = require("ftvim.utils")

			local path = utils.join_paths(get_runtime_dir(), "site", "pack", "lazy", "opt", "nvim-treesitter")

			vim.opt.rtp:prepend(path) -- treesitter needs to be before nvim's runtime in rtp

			require("ftvim.core.treesitter").setup()
		end,

		cmd = {

			"TSInstall",

			"TSUninstall",

			"TSUpdate",

			"TSUpdateSync",

			"TSInstallInfo",

			"TSInstallSync",

			"TSInstallFromGrammar",
		},

		event = "User FileOpened",
	},

	-- NvimTree

	{

		"nvim-tree/nvim-tree.lua",

		config = function()
			require("ftvim.core.nvimtree").setup()
		end,

		enabled = ftvim.builtin.nvimtree.active,

		cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },

		event = "User DirOpened",
	},

	-- Lir

	{

		"tamago324/lir.nvim",

		config = function()
			require("ftvim.core.lir").setup()
		end,

		enabled = ftvim.builtin.lir.active,

		event = "User DirOpened",
	},

	{

		"lewis6991/gitsigns.nvim",

		config = function()
			require("ftvim.core.gitsigns").setup()
		end,

		event = "User FileOpened",

		cmd = "Gitsigns",

		enabled = ftvim.builtin.gitsigns.active,
	},

	-- Whichkey

	{

		"folke/which-key.nvim",

		config = function()
			require("ftvim.core.which-key").setup()
		end,

		cmd = "WhichKey",

		event = "VeryLazy",

		enabled = ftvim.builtin.which_key.active,
	},

	-- Comments

	{

		"numToStr/Comment.nvim",

		config = function()
			require("ftvim.core.comment").setup()
		end,

		keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },

		event = "User FileOpened",

		enabled = ftvim.builtin.comment.active,
	},

	-- project.nvim

	{

		"ahmedkhalf/project.nvim",

		config = function()
			require("ftvim.core.project").setup()
		end,

		enabled = ftvim.builtin.project.active,

		event = "VimEnter",

		cmd = "Telescope projects",
	},

	-- Icons

	{

		"nvim-tree/nvim-web-devicons",

		enabled = ftvim.use_icons,

		lazy = true,
	},

	-- Status Line and Bufferline

	{

		-- "hoob3rt/lualine.nvim",

		"nvim-lualine/lualine.nvim",

		-- "Lunarvim/lualine.nvim",

		config = function()
			require("ftvim.core.lualine").setup()
		end,

		event = "VimEnter",

		enabled = ftvim.builtin.lualine.active,
	},

	{

		"akinsho/bufferline.nvim",

		config = function()
			require("ftvim.core.bufferline").setup()
		end,

		branch = "main",

		event = "User FileOpened",

		enabled = ftvim.builtin.bufferline.active,
	},

	-- alpha

	{

		"goolord/alpha-nvim",

		config = function()
			require("ftvim.core.alpha").setup()
		end,

		enabled = ftvim.builtin.alpha.active,

		event = "VimEnter",
	},

	-- Terminal

	{

		"akinsho/toggleterm.nvim",

		branch = "main",

		init = function()
			require("ftvim.core.terminal").init()
		end,

		config = function()
			require("ftvim.core.terminal").setup()
		end,

		cmd = {

			"ToggleTerm",

			"TermExec",

			"ToggleTermToggleAll",

			"ToggleTermSendCurrentLine",

			"ToggleTermSendVisualLines",

			"ToggleTermSendVisualSelection",
		},

		keys = ftvim.builtin.terminal.open_mapping,

		enabled = ftvim.builtin.terminal.active,
	},

	{

		"RRethy/vim-illuminate",

		config = function()
			require("ftvim.core.illuminate").setup()
		end,

		event = "User FileOpened",

		enabled = ftvim.builtin.illuminate.active,
	},

	{

		"lukas-reineke/indent-blankline.nvim",

		config = function()
			require("ftvim.core.indentlines").setup()
		end,

		event = "User FileOpened",

		enabled = ftvim.builtin.indentlines.active,
	},
}