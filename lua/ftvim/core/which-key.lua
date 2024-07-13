local M = {}

M.config = function()
	ftvim.builtin.which_key = {
		---@usage disable which-key completely [not recommended]
		active = true,
		on_config_done = nil,
		setup = {
			plugins = {
				marks = false, -- shows a list of your marks on ' and `
				registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
				spelling = {
					enabled = true,
					suggestions = 20,
				}, -- use which-key for spelling hints
				-- the presets plugin, adds help for a bunch of default keybindings in Neovim
				-- No actual key bindings are created
				presets = {
					operators = false, -- adds help for operators like d, y, ...
					motions = false, -- adds help for motions
					text_objects = false, -- help for text objects triggered after entering an operator
					windows = false, -- default bindings on <c-w>
					nav = false, -- misc bindings to work with windows
					z = false, -- bindings for folds, spelling and others prefixed with z
					g = false, -- bindings for prefixed with g
				},
			},
			-- add operators that will trigger motion and text object completion
			-- to enable all native operators, set the preset / operators plugin above
			operators = { gc = "Comments" },
			key_labels = {
			},
			icons = {
				breadcrumb = ftvim.icons.ui.DoubleChevronRight, -- symbol used in the command line area that shows your active key combo
				separator = ftvim.icons.ui.BoldArrowRight, -- symbol used between a key and it's label
				group = ftvim.icons.ui.Plus, -- symbol prepended to a group
			},
			popup_mappings = {
				scroll_down = "<c-d>", -- binding to scroll down inside the popup
				scroll_up = "<c-u>", -- binding to scroll up inside the popup
			},
			window = {
				border = "single", -- none, single, double, shadow
				position = "bottom", -- bottom, top
				margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
				padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
				winblend = 0,
			},
			layout = {
				height = { min = 4, max = 25 }, -- min and max height of the columns
				width = { min = 20, max = 50 }, -- min and max width of the columns
				spacing = 3, -- spacing between columns
				align = "left", -- align columns left, center or right
			},
			ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
			hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
			show_help = true, -- show help message on the command line when the popup is visible
			show_keys = true, -- show the currently pressed key and its label as a message in the command line
			triggers = "auto", -- automatically setup triggers
			-- triggers = {"<leader>"} -- or specify a list manually
			triggers_blacklist = {
				-- list of mode / prefixes that should never be hooked by WhichKey
				-- this is mostly relevant for key maps that start with a native binding
				-- most people should not need to change this
				i = { "j", "k" },
				v = { "j", "k" },
			},
			-- disable the WhichKey popup for certain buf types and file types.
			-- Disabled by default for Telescope
			disable = {
				buftypes = {},
				filetypes = { "TelescopePrompt" },
			},
		},

		keymaps = {
			{ "", "<leader>gL", desc = "<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>", nowait = true, remap = false },
			{ "", "<leader>bj", desc = "<cmd>BufferLinePick<cr>", nowait = true, remap = false },
			{ "", "<leader>bh", desc = "<cmd>BufferLineCloseLeft<cr>", nowait = true, remap = false },
			{ "", "<leader>bf", desc = "<cmd>Telescope buffers previewer=false<cr>", nowait = true, remap = false },
			{ "", "<leader>bl", desc = "<cmd>BufferLineCloseRight<cr>", nowait = true, remap = false },
			{ "", group = "Code", nowait = true, remap = false },
			{ "", "<leader>bn", desc = "<cmd>BufferLineCycleNext<cr>", nowait = true, remap = false },
			{ "", "<leader>ca", desc = "<cmd>lua vim.lsp.buf.code_action()<cr>", nowait = true, remap = false },
			{ "", "<leader>be", desc = "<cmd>BufferLinePickClose<cr>", nowait = true, remap = false },
			{ "", "<leader>bb", desc = "<cmd>BufferLineCyclePrev<cr>", nowait = true, remap = false },
			{ "", group = "Buffers", nowait = true, remap = false },
			{ "", "<leader>Ti", desc = ":TSConfigInfo<cr>", nowait = true, remap = false },
			{ "", "<leader>bd", desc = "<cmd>bdelete<CR>", nowait = true, remap = false },
			{ "", "<leader>bD", desc = "<cmd>BufferLineSortByDirectory<cr>", nowait = true, remap = false },
			{ "", "<leader>bW", desc = "<cmd>noautocmd w<cr>", nowait = true, remap = false },
			{ "", "<leader>bL", desc = "<cmd>BufferLineSortByExtension<cr>", nowait = true, remap = false },
			{ "", group = "Treesitter", nowait = true, remap = false },
			{ "", "<leader>cm", desc = "<cmd>Mason<cr>", nowait = true, remap = false },
			{ "", group = "Find", nowait = true, remap = false },
			{ "", "<leader>fp", desc = "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>", nowait = true, remap = false },
			{ "", "<leader>fl", desc = "<cmd>Telescope resume<cr>", nowait = true, remap = false },
			{ "", "<leader>fk", desc = "<cmd>Telescope keymaps<cr>", nowait = true, remap = false },
			{ "", "<leader>fr", desc = "<cmd>Telescope oldfiles<cr>", nowait = true, remap = false },
			{ "", "<leader>ft", desc = "<cmd>Telescope colorscheme<cr>", nowait = true, remap = false },
			{ "", "<leader>fs", desc = "<cmd>Telescope live_grep<cr>", nowait = true, remap = false },
			{ "", "<leader>e", desc = "<cmd>NvimTreeToggle<CR>", nowait = true, remap = false },
			{ "", "<leader>fh", desc = "<cmd>Telescope help_tags<cr>", nowait = true, remap = false },
			{ "", "<leader>fc", desc = "<cmd>Telescope grep_string<cr>", nowait = true, remap = false },
			{ "", "<leader>fH", desc = "<cmd>Telescope highlights<cr>", nowait = true, remap = false },
			{ "", "<leader>fC", desc = "<cmd>Telescope commands<cr>", nowait = true, remap = false },
			{ "", "<leader>ff", desc = "<cmd>Telescope find_files<cr>", nowait = true, remap = false },
			{ "", "<leader>fM", desc = "<cmd>Telescope man_pages<cr>", nowait = true, remap = false },
			{ "", "<leader>fb", desc = "<cmd>Telescope git_branches<cr>", nowait = true, remap = false },
			{ "", "<leader>fR", desc = "<cmd>Telescope registers<cr>", nowait = true, remap = false },
			{ "", "<leader>Fk", desc = "<cmd>Telescope keymaps<cr>", nowait = true, remap = false },
			{ "", "<leader>;", desc = "<cmd>Alpha<CR>", nowait = true, remap = false },
			{ "", "<leader>gr", desc = "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", nowait = true, remap = false },
			{ "", "<leader>gp", desc = "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", nowait = true, remap = false },
			{ "", "<leader>go", desc = "<cmd>Telescope git_status<cr>", nowait = true, remap = false },
			{ "", "<leader>gs", desc = "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", nowait = true, remap = false },
			{ "", group = "Plugins", nowait = true, remap = false },
			{ "", "<leader>gu", desc = "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", nowait = true, remap = false },
			{ "", "<leader>pS", desc = "<cmd>Lazy clear<cr>", nowait = true, remap = false },
			{ "", "<leader>gl", desc = "<cmd>lua require 'gitsigns'.blame_line()<cr>", nowait = true, remap = false },
			{ "", "<leader>gj", desc = "<cmd>lua require 'gitsigns'.nav_hunk('next', {navigation_message = false})<cr>", nowait = true, remap = false },
			{ "", "<leader>gb", desc = "<cmd>Telescope git_branches<cr>", nowait = true, remap = false },
			{ "", "<leader>gR", desc = "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", nowait = true, remap = false },
			{ "", "<leader>gk", desc = "<cmd>lua require 'gitsigns'.nav_hunk('prev', {navigation_message = false})<cr>", nowait = true, remap = false },
			{ "", "<leader>gc", desc = "<cmd>Telescope git_commits<cr>", nowait = true, remap = false },
			{ "", "<leader>gg", desc = "<cmd>lua require 'ftvim.core.terminal'.lazygit_toggle()<cr>", nowait = true, remap = false },
			{ "", "<leader>gd", desc = "<cmd>Gitsigns diffthis HEAD<cr>", nowait = true, remap = false },
			{ "", group = "FtVim", nowait = true, remap = false },
			{ "", "<leader>pi", desc = "<cmd>Lazy install<cr>", nowait = true, remap = false },
			{ "", "<leader>ps", desc = "<cmd>Lazy sync<cr>", nowait = true, remap = false },
			{ "", "<leader>ww", desc = "<cmd>split new<cr>", nowait = true, remap = false },
			{ "", "<leader>wsv", desc = "<cmd>vsplit<cr>", nowait = true, remap = false },
			{ "", "<leader>/", desc = "<Plug>(comment_toggle_linewise_current)", nowait = true, remap = false },
			{ "", "<leader>pl", desc = "<cmd>Lazy<cr>", nowait = true, remap = false },
			{ "", "<leader>wsh", desc = "<cmd>split<cr>", nowait = true, remap = false },
			{ "", "<leader>wd", desc = "<cmd>q<cr>", nowait = true, remap = false },
			{ "", "<leader>pu", desc = "<cmd>Lazy update<cr>", nowait = true, remap = false },
			{ "", group = "Split", nowait = true, remap = false },
			{ "", group = "Quit", nowait = true, remap = false },
			{ "", group = "Windows", nowait = true, remap = false },
			{ "", "<leader>qq", desc = "<cmd>confirm q<CR>", nowait = true, remap = false },
			{ "", "<leader>gC", desc = "<cmd>Telescope git_bcommits<cr>", nowait = true, remap = false },
			{
				mode = { "v" },
				{ "", "<leader>/", desc = "<Plug>(comment_toggle_linewise_visual)", nowait = true, remap = false },
				{ "", "<leader>gr", desc = "<cmd>Gitsigns reset_hunk<cr>", nowait = true, remap = false },
				{ "", "<leader>gs", desc = "<cmd>Gitsigns stage_hunk<cr>", nowait = true, remap = false },
			},
			{ "", group = "Git", mode = { "n", "v" }, nowait = true, remap = false },
		}
	}
end

M.setup = function()
	local which_key = require("which-key")

	which_key.setup(ftvim.builtin.which_key.setup)

	local mappings = ftvim.builtin.which_key.keymaps

	which_key.register(mappings)

	if ftvim.builtin.which_key.on_config_done then
		ftvim.builtin.which_key.on_config_done(which_key)
	end
end

return M
