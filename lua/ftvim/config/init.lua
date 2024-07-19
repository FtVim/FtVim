local M = {}

function M:init()
	ftvim = vim.deepcopy(require("ftvim.config.defaults"))

	vim.g.mapleader = (ftvim.leader == "space" and " ") or ftvim.leader
	vim.g.maplocalleader = " "

	local keymappings = require("ftvim.keymappings")
	keymappings.load_defaults()

	local builtins = require("ftvim.core.builtins")
	builtins.config()

	local settings = require("ftvim.config.settings")
	settings.load_defaults()
end

return M
