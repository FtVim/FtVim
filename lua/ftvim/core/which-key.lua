local M = {}

M.config = function()
	local wk = require("which-key")

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
				-- add operators that will trigger motion and text object completion
				-- to enable all native operators, set the preset / operators plugin above
				operators = { gc = "Comments" },
				key_labels = {
					-- override the label used to display some keys. It doesn't effect WK in any other way.
					-- For example:
					-- ["<space>"] = "SPC",
					-- ["<cr>"] = "RET",
					-- ["<tab>"] = "TAB",
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

			wk.add({
				{
					"<leader>/",
					"<Plug>(comment_toggle_linewise_current)",
					desc = "Comment toggle current line",
					nowait = true,
					remap = false,
				},
				{ "<leader>;", "<cmd>Alpha<CR>", desc = "Dashboard", nowait = true, remap = false },
				{ "<leader>F", group = "FtVim", nowait = true, remap = false },
				{
					"<leader>Fk",
					"<cmd>Telescope keymaps<cr>",
					desc = "View FtVim's keymappings",
					nowait = true,
					remap = false,
				},
				{ "<leader>T", group = "Treesitter", nowait = true, remap = false },
				{ "<leader>Ti", ":TSConfigInfo<cr>", desc = "Info", nowait = true, remap = false },
				{ "<leader>b", group = "Buffers", nowait = true, remap = false },
				{
					"<leader>bD",
					"<cmd>BufferLineSortByDirectory<cr>",
					desc = "Sort by directory",
					nowait = true,
					remap = false,
				},
				{
					"<leader>bL",
					"<cmd>BufferLineSortByExtension<cr>",
					desc = "Sort by language",
					nowait = true,
					remap = false,
				},
				{
					"<leader>bW",
					"<cmd>noautocmd w<cr>",
					desc = "Save without formatting (noautocmd)",
					nowait = true,
					remap = false,
				},
				{ "<leader>bb", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous", nowait = true, remap = false },
				{ "<leader>bd", "<cmd>bdelete<CR>", desc = "Close Buffer", nowait = true, remap = false },
				{
					"<leader>be",
					"<cmd>BufferLinePickClose<cr>",
					desc = "Pick which buffer to close",
					nowait = true,
					remap = false,
				},
				{
					"<leader>bf",
					"<cmd>Telescope buffers previewer=false<cr>",
					desc = "Find",
					nowait = true,
					remap = false,
				},
				{
					"<leader>bh",
					"<cmd>BufferLineCloseLeft<cr>",
					desc = "Close all to the left",
					nowait = true,
					remap = false,
				},
				{ "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump", nowait = true, remap = false },
				{
					"<leader>bl",
					"<cmd>BufferLineCloseRight<cr>",
					desc = "Close all to the right",
					nowait = true,
					remap = false,
				},
				{ "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next", nowait = true, remap = false },
				{ "<leader>c", group = "Code", nowait = true, remap = false },
				{
					"<leader>ca",
					"<cmd>lua vim.lsp.buf.code_action()<cr>",
					desc = "Code action",
					nowait = true,
					remap = false,
				},
				{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason", nowait = true, remap = false },
				{ "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer", nowait = true, remap = false },
				{ "<leader>f", group = "Find", nowait = true, remap = false },
				{ "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands", nowait = true, remap = false },
				{
					"<leader>fH",
					"<cmd>Telescope highlights<cr>",
					desc = "Find highlight groups",
					nowait = true,
					remap = false,
				},
				{ "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages", nowait = true, remap = false },
				{ "<leader>fR", "<cmd>Telescope registers<cr>", desc = "Registers", nowait = true, remap = false },
				{
					"<leader>fb",
					"<cmd>Telescope git_branches<cr>",
					desc = "Checkout branch",
					nowait = true,
					remap = false,
				},
				{
					"<leader>fc",
					"<cmd>Telescope grep_string<cr>",
					desc = "Find string under cursor in cwd",
					nowait = true,
					remap = false,
				},
				{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", nowait = true, remap = false },
				{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find Help", nowait = true, remap = false },
				{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps", nowait = true, remap = false },
				{
					"<leader>fl",
					"<cmd>Telescope resume<cr>",
					desc = "Resume last search",
					nowait = true,
					remap = false,
				},
				{
					"<leader>fp",
					"<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
					desc = "Colorscheme with Preview",
					nowait = true,
					remap = false,
				},
				{
					"<leader>fr",
					"<cmd>Telescope oldfiles<cr>",
					desc = "Open Recent File",
					nowait = true,
					remap = false,
				},
				{
					"<leader>fs",
					"<cmd>Telescope live_grep<cr>",
					desc = "Find string in cwd",
					nowait = true,
					remap = false,
				},
				{ "<leader>ft", "<cmd>Telescope colorscheme<cr>", desc = "Change theme", nowait = true, remap = false },
				{ "<leader>g", group = "Git", nowait = true, remap = false },
				{
					"<leader>gC",
					"<cmd>Telescope git_bcommits<cr>",
					desc = "Checkout commit(for current file)",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gL",
					"<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>",
					desc = "Blame Line (full)",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gR",
					"<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
					desc = "Reset Buffer",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gb",
					"<cmd>Telescope git_branches<cr>",
					desc = "Checkout branch",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gc",
					"<cmd>Telescope git_commits<cr>",
					desc = "Checkout commit",
					nowait = true,
					remap = false,
				},
				{ "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff", nowait = true, remap = false },
				{
					"<leader>gg",
					"<cmd>lua require 'ftvim.core.terminal'.lazygit_toggle()<cr>",
					desc = "Lazygit",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gj",
					"<cmd>lua require 'gitsigns'.nav_hunk('next', {navigation_message = false})<cr>",
					desc = "Next Hunk",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gk",
					"<cmd>lua require 'gitsigns'.nav_hunk('prev', {navigation_message = false})<cr>",
					desc = "Prev Hunk",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gl",
					"<cmd>lua require 'gitsigns'.blame_line()<cr>",
					desc = "Blame",
					nowait = true,
					remap = false,
				},
				{
					"<leader>go",
					"<cmd>Telescope git_status<cr>",
					desc = "Open changed file",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gp",
					"<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
					desc = "Preview Hunk",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gr",
					"<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
					desc = "Reset Hunk",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gs",
					"<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
					desc = "Stage Hunk",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gu",
					"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
					desc = "Undo Stage Hunk",
					nowait = true,
					remap = false,
				},
				{ "<leader>p", group = "Plugins", nowait = true, remap = false },
				{ "<leader>pS", "<cmd>Lazy clear<cr>", desc = "Status", nowait = true, remap = false },
				{ "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install", nowait = true, remap = false },
				{ "<leader>pl", "<cmd>Lazy<cr>", desc = "Log", nowait = true, remap = false },
				{ "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync", nowait = true, remap = false },
				{ "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update", nowait = true, remap = false },
				{ "<leader>q", group = "Quit", nowait = true, remap = false },
				{ "<leader>qq", "<cmd>confirm q<CR>", desc = "Quit", nowait = true, remap = false },
				{ "<leader>w", group = "Windows", nowait = true, remap = false },
				{ "<leader>wd", "<cmd>q<cr>", desc = "Delete Window", nowait = true, remap = false },
				{ "<leader>ws", group = "Split", nowait = true, remap = false },
				{ "<leader>wsh", "<cmd>split<cr>", desc = "Split Horizontal", nowait = true, remap = false },
				{ "<leader>wsv", "<cmd>vsplit<cr>", desc = "Split Vertical", nowait = true, remap = false },
				{ "<leader>ww", "<cmd>split new<cr>", desc = "Other Window", nowait = true, remap = false },
				{
					"<leader>/",
					"<Plug>(comment_toggle_linewise_visual)",
					desc = "Comment toggle linewise (visual)",
					mode = { "v" },
					nowait = true,
					remap = false,
				},
				{ "<leader>g", mode = { "v" }, group = "Git", nowait = true, remap = false },
				{
					"<leader>gr",
					"<cmd>Gitsigns reset_hunk<cr>",
					mode = { "v" },
					desc = "Reset Hunk",
					nowait = true,
					remap = false,
				},
				{
					"<leader>gs",
					"<cmd>Gitsigns stage_hunk<cr>",
					mode = { "v" },
					desc = "Stage Hunk",
					nowait = true,
					remap = false,
				},
			})
		}
	}
end

M.setup = function()
	local which_key = require("which-key")

	which_key.setup(ftvim.builtin.which_key.setup)

	if ftvim.builtin.which_key.on_config_done then
		ftvim.builtin.which_key.on_config_done(which_key)
	end
end

return M
