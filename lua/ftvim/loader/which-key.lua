local M = {}

local icons = require("ftvim.config").icons

M.opts = {
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
		icons = {
			breadcrumb = icons.ui.DoubleChevronRight, -- symbol used in the command line area that shows your active key combo
			separator = icons.ui.BoldArrowRight, -- symbol used between a key and it's label
			group = icons.ui.Plus, -- symbol prepended to a group
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
			align = "center", -- align columns left, center or right
		},
		show_help = true, -- show help message on the command line when the popup is visible
		show_keys = true, -- show the currently pressed key and its label as a message in the command line
		triggers = { "<leader>" }, -- automatically setup triggers
		-- triggers = {"<leader>"} -- or specify a list manually
		-- Disabled by default for Telescope
		disable = {
			buftypes = {},
			filetypes = { "TelescopePrompt" },
		},
		preset = "modern",
}

M.setup = function()
	local which_key = require("which-key")

	which_key.setup(M.opts)

	which_key.add({
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
		{ "<leader>Ff", "<cmd>CFormatter42<cr>", nowait = true, desc = "C formatter", remap = false },
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
		{ "<leader>cd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Goto Definition", nowait = true, remap = false },
		{
			"<leader>ci",
			"<cmd>lua vim.lsp.buf.implementation()<cr>",
			desc = "Goto Implementation",
			nowait = true,
			remap = false,
		},
		{
			"<leader>cr",
			"<cmd>lua vim.lsp.buf.references()<cr>",
			desc = "Goto References",
			nowait = true,
			remap = false,
		},
		{
			"<leader>cs",
			"<cmd>lua vim.lsp.buf.signature_help()<cr>",
			desc = "Signature Help",
			nowait = true,
			remap = false,
		},
		{
			"<leader>ct",
			"<cmd>lua vim.lsp.buf.type_definition()<cr>",
			desc = "Goto Type Definition",
			nowait = true,
			remap = false,
		},
		{
			"<leader>cv",
			"<cmd>lua vim.lsp.buf.hover()<cr>",
			desc = "Hover",
			nowait = true,
			remap = false,
		},
		{
			"<leader>cx",
			"<cmd>lua vim.lsp.buf.rename()<cr>",
			desc = "Rename",
			nowait = true,
			remap = false,
		},
		{ "<leader>cm", group = "Mason", nowait = true, remap = false },
		{ "<leader>cm", "<cmd>Mason<cr>", desc = "Mason", nowait = true, remap = false },
		{ "<leader>e", "<cmd>Neotree toggle reveal_force_cwd<CR>", desc = "Explorer", nowait = true, remap = false },
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
		-- { "<leader>ft", "<cmd>Telescope colorscheme<cr>", desc = "Change theme", nowait = true, remap = false },
		{ "<leader>g", group = "Git", nowait = true, remap = false },
		{
			"<leader>gC",
			"<cmd>Telescope git_bcommits<cr>",
			desc = "Checkout commit(for current file)",
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
		{
			"<leader>go",
			"<cmd>Telescope git_status<cr>",
			desc = "Open changed file",
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
	})
end

return M
