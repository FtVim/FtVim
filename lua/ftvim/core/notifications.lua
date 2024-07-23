local M = {}

M.config = function()
	ftvim.builtin.notify = {
		active = true,
		on_config_done = nil,
		options = {
			stages = "slide",
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { zindex = 100 })
			end,
		},
		keymaps = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss All Notifications",
			},
		},
	}
end

M.setup = function()
    local status_ok, notify = pcall(require, "notify")
    if not status_ok then
        vim.notify("Error loading nvim-notify", vim.log.levels.ERROR)
        return
    end

    local config_ok, _ = pcall(notify.setup, ftvim.builtin.notify.options)
    if not config_ok then
        return
    end

    vim.notify = notify

    for _, keymap in ipairs(ftvim.builtin.notify.keymaps) do
        vim.keymap.set("n", keymap[1], keymap[2], { desc = keymap.desc, silent = true, noremap = true })
    end

    if ftvim.builtin.notify.on_config_done then
        ftvim.builtin.notify.on_config_done()
    end
end

return M
