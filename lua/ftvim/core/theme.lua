local M = {}

M.config = function()
	ftvim.builtin.theme = {
		event = "VimEnter",
		name = "tokyonight",
		tokyonight = {
			options = {
				on_highlights = function(hl, c)
					hl.IndentBlanklineContextChar = {
						fg = c.dark5,
					}
					hl.TSConstructor = {
						fg = c.blue1,
					}
					hl.TSTagDelimiter = {
						fg = c.dark5,
					}
				end,
				style = "night",
				transparent = ftvim.transparent_window,
				terminal_colors = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					sidebars = "dark",
					floats = "dark",
				},
				sidebars = {
					"qf",
					"vista_kind",
					"terminal",
					"packer",
					"spectre_panel",
					"NeogitStatus",
					"help",
				},
				day_brightness = 0.3,
				hide_inactive_statusline = false,
				dim_inactive = false,
				lualine_bold = false,
				use_background = true,
			},
		},
	}
end

M.setup = function()
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	local selected_theme = ftvim.builtin.theme.name
	-- print("Selected theme: " .. selected_theme)

	if vim.startswith(ftvim.colorscheme, selected_theme) then
		local status_ok, plugin = pcall(require, selected_theme)
		if not status_ok then
			-- print("Failed to load theme: " .. selected_theme)
			-- print("Error: " .. plugin)  -- Añadir este mensaje para obtener detalles del error
			return
		end
		pcall(function()
			plugin.setup(ftvim.builtin.theme[selected_theme].options)
		end)
	end

	local colors = vim.api.nvim_get_runtime_file(("colors/%s.*"):format(ftvim.colorscheme), false)
	if #colors == 0 then
		-- print("Colorscheme file not found: " .. ftvim.colorscheme)
		return
	end

	vim.g.colors_name = ftvim.colorscheme
	vim.cmd("colorscheme " .. ftvim.colorscheme)

	if package.loaded.lualine then
		require("ftvim.core.lualine").setup()
	end
	if package.loaded.lir then
		require("ftvim.core.lir").icon_setup()
	end
end

return M
