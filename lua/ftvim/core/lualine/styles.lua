local M = {}
local components = require("ftvim.core.lualine.components")

local styles = {
	ftvim = nil,
	default = nil,
	none = nil,
}

styles.none = {
	style = "none",
	options = {
		theme = "auto",
		globalstatus = true,
		icons_enabled = ftvim.use_icons,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {},
	},
	sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
}

styles.default = {
	style = "default",
	options = {
		theme = "auto",
		globalstatus = true,
		icons_enabled = ftvim.use_icons,
		component_separators = {
			left = ftvim.icons.ui.DividerRight,
			right = ftvim.icons.ui.DividerLeft,
		},
		section_separators = {
			left = ftvim.icons.ui.BoldDividerRight,
			right = ftvim.icons.ui.BoldDividerLeft,
		},
		disabled_filetypes = {},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
}

styles.ftvim = {
	style = "ftvim",
	options = {
		theme = "auto",
		globalstatus = true,
		icons_enabled = ftvim.use_icons,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha" },
	},
	sections = {
		lualine_a = {
			components.mode,
		},
		lualine_b = {
			components.branch,
		},
		lualine_c = {
			components.diff,
			components.python_env,
		},
		lualine_x = {
			components.diagnostics,
			components.lsp,
			components.spaces,
			components.filetype,
		},
		lualine_y = { components.location },
		lualine_z = {
			components.progress,
		},
	},
	inactive_sections = {
		lualine_a = {
			components.mode,
		},
		lualine_b = {
			components.branch,
		},
		lualine_c = {
			components.diff,
			components.python_env,
		},
		lualine_x = {
			components.diagnostics,
			components.lsp,
			components.spaces,
			components.filetype,
		},
		lualine_y = { components.location },
		lualine_z = {
			components.progress,
		},
	},
	tabline = {},
	extensions = {},
}

function M.get_style(style)
	local style_keys = vim.tbl_keys(styles)
	if not vim.tbl_contains(style_keys, style) then
		local Log = require("ftvim.core.log")
		Log:error(
			"Invalid lualine style"
				.. string.format('"%s"', style)
				.. "options are: "
				.. string.format('"%s"', table.concat(style_keys, '", "'))
		)
		Log:debug('"ftvim" style is applied.')
		style = "ftvim"
	end

	return vim.deepcopy(styles[style])
end

function M.update()
	local style = M.get_style(ftvim.builtin.lualine.style)

	ftvim.builtin.lualine = vim.tbl_deep_extend("keep", ftvim.builtin.lualine, style)

	local color_template = vim.g.colors_name or ftvim.colorscheme
	local theme_supported, template = pcall(function()
		require("lualine.utils.loader").load_theme(color_template)
	end)
	if theme_supported and template then
		ftvim.builtin.lualine.options.theme = color_template
	end
end

return M
