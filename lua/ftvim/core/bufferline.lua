local M = {}

M.config = function()
	ftvim.builtin.bufferline = {
		active = true,
		options = {
			-- stylua: ignore
			close_command = function(n) require("mini.bufremove").delete(n, false) end,
			-- stylua: ignore
			right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
			diagnostics = "nvim_lsp",
			always_show_bufferline = false,
			offsets = {
				{
					filetype = "neo-tree",
					text = "Neo-tree",
					highlight = "Directory",
					text_align = "left",
				},	
			},
		},
	}
end

M.setup = function()
	require("ftvim.keymappings").load(ftvim.builtin.bufferline.keymap)

	local status_ok, bufferline = pcall(require, "bufferline")
	if not status_ok then
		return
	end

	-- can't be set in settings.lua because default tabline would flash before bufferline is loaded
	vim.opt.showtabline = 2

	bufferline.setup({
		options = ftvim.builtin.bufferline.options,
		highlights = ftvim.builtin.bufferline.highlights,
	})

	if ftvim.builtin.bufferline.on_config_done then
		ftvim.builtin.bufferline.on_config_done()
	end
end

return M
