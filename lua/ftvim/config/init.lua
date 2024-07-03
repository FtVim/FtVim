local M = {}

function M:init()
	ftvim = vim.deepcopy(require("ftvim.config.defaults"))

	local keymappings = require("ftvim.keymappings")
	keymappings.load_defaults()

	local builtins = require("ftvim.core.builtins")
	builtins.config()

	local settings = require("ftvim.config.settings")
	settings.load_defaults()
	vim.cmd("colorscheme " .. ftvim.colorscheme)
end

return M
