local M = {}
local icons = require("ftvim.config").icons
local colors = {
	bg = "#202328",
	fg = "#bbc2cf",
	yellow = "#ECBE7B",
	cyan = "#008080",
	darkblue = "#081633",
	green = "#98be65",
	orange = "#FF8800",
	violet = "#a9a1e1",
	magenta = "#c678dd",
	purple = "#c678dd",
	blue = "#51afef",
	red = "#ec5f67",
}
local window_width_limit = 100

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.o.columns > window_width_limit
	end,
	-- check_git_workspace = function()
	--   local filepath = vim.fn.expand "%:p:h"
	--   local gitdir = vim.fn.finddir(".git", filepath .. ";")
	--   return gitdir and #gitdir > 0 and #gitdir < #filepath
	-- end,
}

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local components = {
	mode = {
		function()
			return " " .. require("ftvim.config").icons.ui.FtVim .. " "
		end,
		padding = { left = 0, right = 0 },
		color = {},
		cond = nil,
	},
	filename = {
		"filename",
		color = {},
		cond = nil,
	},
	diff = {
		"diff",
		source = diff_source,
		symbols = {
			added = icons.git.LineAdded .. " ",
			modified = icons.git.LineModified .. " ",
			removed = icons.git.LineRemoved .. " ",
		},
		padding = { left = 2, right = 1 },
		diff_color = {
			added = { fg = colors.green },
			modified = { fg = colors.yellow },
			removed = { fg = colors.red },
		},
		cond = nil,
	},
	python_env = {
		function()
			local utils = require("ftvim.core.lualine.utils")
			if vim.bo.filetype == "python" then
				local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
				if venv then
					local icons_ = require("nvim-web-devicons")
					local py_icon, _ = icons_.get_icon(".py")
					return string.format(" " .. py_icon .. " (%s)", utils.env_cleanup(venv))
				end
			end
			return ""
		end,
		color = { fg = colors.green },
		cond = conditions.hide_in_width,
	},
	diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		symbols = {
			error = icons.diagnostics.BoldError .. " ",
			warn = icons.diagnostics.BoldWarning .. " ",
			info = icons.diagnostics.BoldInformation .. " ",
			hint = icons.diagnostics.BoldHint .. " ",
		},
		-- cond = conditions.hide_in_width,
	},
	treesitter = {
		function()
			return icons.ui.Tree
		end,
		color = function()
			local buf = vim.api.nvim_get_current_buf()
			local ts = vim.treesitter.highlighter.active[buf]
			return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
		end,
		cond = conditions.hide_in_width,
	},
	lsp = {
		function()
			local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
			if #buf_clients == 0 then
				return "LSP Inactive"
			end

			local buf_ft = vim.bo.filetype
			local buf_client_names = {}
			local copilot_active = false

			-- add client
			for _, client in pairs(buf_clients) do
				if client.name ~= "null-ls" and client.name ~= "copilot" then
					table.insert(buf_client_names, client.name)
				end

				if client.name == "copilot" then
					copilot_active = true
				end
			end


			local unique_client_names = table.concat(buf_client_names, ", ")
			local language_servers = string.format("[%s]", unique_client_names)

			if copilot_active then
				language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
			end

			return language_servers
		end,
		color = { gui = "bold" },
		cond = conditions.hide_in_width,
	},
	location = { "location" },
	progress = {
		"progress",
		fmt = function()
			return "%P/%L"
		end,
		color = {},
	},
	datetime = {
      'datetime',
      -- options: default, us, uk, iso, or your own format string ("%H:%M", etc..)
      style = 'default'
	},

	spaces = {
		function()
			local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
			return icons.ui.Tab .. " " .. shiftwidth
		end,
		padding = 1,
	},
	encoding = {
		"o:encoding",
		fmt = string.upper,
		color = {},
		cond = conditions.hide_in_width,
	},
	filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } },
	scrollbar = {
		function()
			local current_line = vim.fn.line(".")
			local total_lines = vim.fn.line("$")
			local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
			local line_ratio = current_line / total_lines
			local index = math.ceil(line_ratio * #chars)
			return chars[index]
		end,
		padding = { left = 0, right = 0 },
		color = "SLProgress",
		cond = nil,
	},
}

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
		icons_enabled = true,
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
		icons_enabled = true,
		component_separators = {
			left = icons.ui.DividerRight,
			right = icons.ui.DividerLeft,
		},
		section_separators = {
			left = icons.ui.BoldDividerRight,
			right = icons.ui.BoldDividerLeft,
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
		icons_enabled = true,
		component_separators = { left = "|", right = "|" },
		section_separators = { left = '', right = ''},
		disabled_filetypes = { "alpha" },
	},
	sections = {
		lualine_a = {
			components.mode,
			"mode"
		},
		lualine_b = {
			"branch",
		},
		lualine_c = {
			components.diff,
			components.python_env,
		},
		lualine_x = {
			components.diagnostics,
			components.lsp,
			-- components.spaces,
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
		print(
			"Invalid lualine style"
				.. string.format('"%s"', style)
				.. "options are: "
				.. string.format('"%s"', table.concat(style_keys, '", "'))
		)
		print('"ftvim" style is applied.')
		style = "ftvim"
	end

	return vim.deepcopy(styles[style])
end

function M.update()
	local style = M.get_style(M.style)

	M.config = vim.tbl_deep_extend("keep", M.config, style)

	local color_template = vim.g.colors_name or require("ftvim.config").colorscheme
	local theme_supported, template = pcall(function()
		require("lualine.utils.loader").load_theme(color_template)
	end)
	if theme_supported and template then
		M.options.theme = color_template
	end
end

M.config = {
	active = true,
	style = "ftvim",
	options = {
		icons_enabled = nil,
		component_separators = nil,
		section_separators = nil,
		theme = nil,
		disabled_filetypes = { statusline = { "alpha" } },
		globalstatus = true,
	},
	sections = {
		lualine_a = nil,
		lualine_b = nil,
		lualine_c = nil,
		lualine_x = nil,
		lualine_y = nil,
		lualine_z = nil,
	},
	inactive_sections = {
		lualine_a = nil,
		lualine_b = nil,
		lualine_c = nil,
		lualine_x = nil,
		lualine_y = nil,
		lualine_z = nil,
	},
	tabline = nil,
	extensions = nil,
	on_config_done = nil,
}

M.setup = function()
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	local status_ok, lualine = pcall(require, "lualine")
	if not status_ok then
		return
	end

	M.update()

	lualine.setup(M.config)
end
return M
