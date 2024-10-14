local M = {}

local actions = require("telescope.actions")
local icons = require("ftvim.config").icons

M.config = {
	---@usage disable telescope completely [not recommended]
	active = true,
	on_config_done = nil,
	theme = "dropdown",
	defaults = {
		prompt_prefix = icons.ui.Telescope .. " ",
		selection_caret = icons.ui.Forward .. " ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = nil,
		layout_strategy = nil,
		layout_config = {},
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"--glob=!.git/",
		},
		---@usage Mappings are fully customizable. Many familiar mapping patterns are setup as defaults.
		mappings = {
			i = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-c>"] = actions.close,
				["<C-j>"] = actions.cycle_history_next,
				["<C-k>"] = actions.cycle_history_prev,
				["<C-q>"] = function(...)
					actions.smart_send_to_qflist(...)
					actions.open_qflist(...)
				end,
				["<CR>"] = actions.select_default,
			},
			n = {
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,
				["<C-q>"] = function(...)
					actions.smart_send_to_qflist(...)
					actions.open_qflist(...)
				end,
			},
		},
		file_ignore_patterns = {},
		path_display = { "smart" },
		winblend = 0,
		border = {},
		borderchars = nil,
		color_devicons = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
	},
	pickers = {
		find_files = {
			hidden = true,
		},
		live_grep = {
			--@usage don't include the filename in the search results
			only_sort_text = true,
		},
		grep_string = {
			only_sort_text = true,
		},
		buffers = {
			initial_mode = "normal",
			mappings = {
				i = {
					["<C-d>"] = actions.delete_buffer,
				},
				n = {
					["dd"] = actions.delete_buffer,
				},
			},
		},
		planets = {
			show_pluto = true,
			show_moon = true,
		},
		git_files = {
			hidden = true,
			show_untracked = true,
		},
		colorscheme = {
			enable_preview = true,
		},
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		},
	},
}

function M.setup()
	local previewers = require("telescope.previewers")
	local sorters = require("telescope.sorters")

	M.config = vim.tbl_extend("keep", {
		file_previewer = previewers.vim_buffer_cat.new,
		grep_previewer = previewers.vim_buffer_vimgrep.new,
		qflist_previewer = previewers.vim_buffer_qflist.new,
		file_sorter = sorters.get_fuzzy_file,
		generic_sorter = sorters.get_generic_fuzzy_sorter,
	}, M.config)

	local telescope = require("telescope")

	local theme = require("telescope.themes")["get_" .. (M.config.theme or "")]
	if theme then
		M.config.defaults = theme(M.config.defaults)
	end

	telescope.setup(M.config)

	if true then
		pcall(function()
			require("telescope").load_extension("projects")
		end)
	end

	if M.config.extensions and M.config.extensions.fzf then
		pcall(function()
			require("telescope").load_extension("fzf")
		end)
	end
end

return M
