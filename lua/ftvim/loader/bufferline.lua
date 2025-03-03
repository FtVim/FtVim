local M = {}
local icons = require("ftvim.config").icons

M.config = {
	keymap = {
		normal_mode = {},
	},
	highlights = {
		background = {
			italic = true,
		},
		buffer_selected = {
			bold = true,
		},
	},
	options = {
		themable = true, -- whether or not bufferline highlights can be overridden externally
		-- style_preset = preset,
		get_element_icon = nil,
		show_duplicate_prefix = true,
		duplicates_across_groups = true,
		auto_toggle_bufferline = true,
		move_wraps_at_ends = false,
		groups = { items = {}, options = { toggle_hidden_on_enter = true } },
		mode = "buffers", -- set to "tabs" to only show tabpages instead
		numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
		close_command = function(n)
			require("mini.bufremove").delete(n, false)
		end,
		right_mouse_command = function(n)
			require("mini.bufremove").delete(n, false)
		end,
		left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
		middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
		indicator = {
			icon = icons.ui.BoldLineLeft, -- this should be omitted if indicator style is not 'icon'
			style = "icon", -- can also be 'underline'|'none',
		},
		buffer_close_icon = icons.ui.Close,
		modified_icon = icons.ui.Circle,
		close_icon = icons.ui.BoldClose,
		left_trunc_marker = icons.ui.ArrowCircleLeft,
		right_trunc_marker = icons.ui.ArrowCircleRight,
		--- name_formatter can be used to change the buffer's label in the bufferline.
		--- Please note some names can/will break the
		--- bufferline so use this at your discretion knowing that it has
		--- some limitations that will *NOT* be fixed.
		name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
			-- remove extension from markdown files for example
			if buf.name:match("%.md") then
				return vim.fn.fnamemodify(buf.name, ":t:r")
			end
		end,
		max_name_length = 18,
		max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
		truncate_names = true, -- whether or not tab names should be truncated
		tab_size = 18,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		offsets = {
			{
				filetype = "neo-tree",
				text = "Neo-tree",
				highlight = "Directory",
				text_align = "left",
				padding = 1,
			},
			{
				filetype = "undotree",
				text = "Undotree",
				highlight = "PanelHeading",
				padding = 1,
			},
			{
				filetype = "NvimTree",
				text = "Explorer",
				highlight = "PanelHeading",
				padding = 1,
			},
			{
				filetype = "DiffviewFiles",
				text = "Diff View",
				highlight = "PanelHeading",
				padding = 1,
			},
			{
				filetype = "flutterToolsOutline",
				text = "Flutter Outline",
				highlight = "PanelHeading",
			},
			{
				filetype = "lazy",
				text = "Lazy",
				highlight = "PanelHeading",
				padding = 1,
			},
		},
		color_icons = true, -- whether or not to add the filetype icon highlights
		show_buffer_icons = true, -- disable filetype icons for buffers
		show_buffer_close_icons = true,
		show_close_icon = false,
		show_tab_indicators = true,
		persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
		-- can also be a table containing 2 custom separators
		-- [focused and unfocused]. eg: { '|', '|' }
		separator_style = "thin",
		enforce_regular_tabs = false,
		always_show_bufferline = false,
		hover = {
			enabled = true, -- requires nvim 0.8+
			delay = 200,
			reveal = { "close" },
		},
		sort_by = "id",
		debug = { logging = false },
	},
}

M.setup = function()
	local status_ok, bufferline = pcall(require, "bufferline")

	if not status_ok then
		print("Error loading bufferline")
		return
	end

	vim.opt.showtabline = 2

	bufferline.setup({
		options = M.config.options,
		highlights = M.config.highlights,
	})
end

return M
