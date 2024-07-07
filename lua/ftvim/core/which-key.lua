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

		opts = {
			mode = "n", -- NORMAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		},
		vopts = {
			mode = "v", -- VISUAL mode
			prefix = "<leader>",
			buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
			silent = true, -- use `silent` when creating keymaps
			noremap = true, -- use `noremap` when creating keymaps
			nowait = true, -- use `nowait` when creating keymaps
		},
		-- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
		-- see https://neovim.io/doc/user/map.html#:map-cmd
		vmappings = {
			["/"] = { "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)" },
			g = {
				name = "Git",
				r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset Hunk" },
				s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage Hunk" },
			},
		},
		mappings = {
			[";"] = { "<cmd>Alpha<CR>", "Dashboard" },
			["w"] = { "<cmd>w!<CR>", "Save" },
			["/"] = { "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
			["bd"] = { "<cmd>bdelete<CR>", "Close Buffer" },
			["f"] = {
				function()
					require("ftvim.core.telescope.finders").find_project_files({ previewer = false })
				end,
				"Find File",
			},
			["e"] = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
			q = {
				name = "Quit",
				q = { "<cmd>confirm q<CR>", "Quit" },
				s = { function() require("persistence").load() end, "Restore Session"},
			},
			b = {
				name = "Buffers",
				j = { "<cmd>BufferLinePick<cr>", "Jump" },
				f = { "<cmd>Telescope buffers previewer=false<cr>", "Find" },
				b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
				n = { "<cmd>BufferLineCycleNext<cr>", "Next" },
				W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
				-- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
				e = {
					"<cmd>BufferLinePickClose<cr>",
					"Pick which buffer to close",
				},
				h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
				l = {
					"<cmd>BufferLineCloseRight<cr>",
					"Close all to the right",
				},
				D = {
					"<cmd>BufferLineSortByDirectory<cr>",
					"Sort by directory",
				},
				L = {
					"<cmd>BufferLineSortByExtension<cr>",
					"Sort by language",
				},
			},
			p = {
				name = "Plugins",
				i = { "<cmd>Lazy install<cr>", "Install" },
				s = { "<cmd>Lazy sync<cr>", "Sync" },
				S = { "<cmd>Lazy clear<cr>", "Status" },
				u = { "<cmd>Lazy update<cr>", "Update" },
				l = { "<cmd>Lazy<cr>", "Log" },
			},
			g = {
				name = "Git",
				g = { "<cmd>lua require 'ftvim.core.terminal'.lazygit_toggle()<cr>", "Lazygit" },
				j = { "<cmd>lua require 'gitsigns'.nav_hunk('next', {navigation_message = false})<cr>", "Next Hunk" },
				k = { "<cmd>lua require 'gitsigns'.nav_hunk('prev', {navigation_message = false})<cr>", "Prev Hunk" },
				l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
				L = { "<cmd>lua require 'gitsigns'.blame_line({full=true})<cr>", "Blame Line (full)" },
				p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
				r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
				R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
				s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
				u = {
					"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
					"Undo Stage Hunk",
				},
				o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
				b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
				C = {
					"<cmd>Telescope git_bcommits<cr>",
					"Checkout commit(for current file)",
				},
				d = {
					"<cmd>Gitsigns diffthis HEAD<cr>",
					"Git Diff",
				},
			},
			F = {
				name = "+FtVim",
				k = { "<cmd>Telescope keymaps<cr>", "View FtVim's keymappings" },
			},
			f = {
				name = "Find",
				b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
				s = { "<cmd>Telescope live_grep<cr>", "Find string in cwd" },
				c = { "<cmd>Telescope grep_string<cr>", "Find string under cursor in cwd" },
				f = { "<cmd>Telescope find_files<cr>", "Find File" },
				h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
				H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
				M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
				r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
				R = { "<cmd>Telescope registers<cr>", "Registers" },
				t = { "<cmd>Telescope colorscheme<cr>", "Change theme" },
				k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
				C = { "<cmd>Telescope commands<cr>", "Commands" },
				l = { "<cmd>Telescope resume<cr>", "Resume last search" },
				p = {
					"<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
					"Colorscheme with Preview",
				},
			},
			T = {
				name = "Treesitter",
				i = { ":TSConfigInfo<cr>", "Info" },
			},
		},
	}
end

M.setup = function()
	local which_key = require("which-key")

	which_key.setup(ftvim.builtin.which_key.setup)

	local opts = ftvim.builtin.which_key.opts
	local vopts = ftvim.builtin.which_key.vopts

	local mappings = ftvim.builtin.which_key.mappings
	local vmappings = ftvim.builtin.which_key.vmappings

	which_key.register(mappings, opts)
	which_key.register(vmappings, vopts)

	if ftvim.builtin.which_key.on_config_done then
		ftvim.builtin.which_key.on_config_done(which_key)
	end
end

return M
