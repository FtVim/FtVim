local M = {}

function M.config()
	local ftvim_dashboard = require("ftvim.core.alpha.dashboard")
	local ftvim_startify = require("ftvim.core.alpha.startify")
	ftvim.builtin.alpha = {
		dashboard = {
			config = {},
			section = ftvim_dashboard.get_sections(),
			opts = { autostart = true },
		},
		startify = {
			config = {},
			section = ftvim_startify.get_sections(),
			opts = { autostart = true },
		},
		active = true,
		mode = "dashboard",
	}
end

local function resolve_buttons(theme_name, button_section)
	if button_section.val and #button_section.val > 0 then
		return button_section.val
	end

	local selected_theme = require("alpha.themes." .. theme_name)
	local val = {}
	for _, entry in pairs(button_section.entries) do
		local on_press = function()
			local sc_ = entry[1]:gsub("%s", ""):gsub("SPC", "<leader>")
			local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
			vim.api.nvim_feedkeys(key, "normal", false)
		end
		local button_element = selected_theme.button(entry[1], entry[2], entry[3])
		button_element.on_press = on_press

		button_element.opts = vim.tbl_extend("force", button_element.opts, entry[4] or button_section.opts or {})

		table.insert(val, button_element)
	end
	return val
end

local function resolve_config(theme_name)
	local selected_theme = require("alpha.themes." .. theme_name)
	local resolved_section = selected_theme.section
	local section = ftvim.builtin.alpha[theme_name].section

	for name, el in pairs(section) do
		for k, v in pairs(el) do
			if name:match("buttons") and k == "entries" then
				resolved_section[name].val = resolve_buttons(theme_name, el)
			elseif v then
				resolved_section[name][k] = v
			end
		end

		resolved_section[name].opts = el.opts or {}
	end

	local opts = ftvim.builtin.alpha[theme_name].opts or {}
	selected_theme.config.opts = vim.tbl_extend("force", selected_theme.config.opts, opts)

	return selected_theme.config
end

function M.setup()
	local status_ok, alpha = pcall(require, "alpha")
	if not status_ok then
		print("Error loading alpha")
		return
	end
	local mode = ftvim.builtin.alpha.mode
	local config = ftvim.builtin.alpha[mode].config

	-- this makes it easier to use a completely custom configuration
	if vim.tbl_isempty(config) then
		config = resolve_config(mode)
	end

	alpha.setup(config)
end

return M
