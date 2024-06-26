local M = {}

function M:init()
	local keymappings = require("ftvim.keymappings")
	keymappings.load_defaults()

	--local builtins = require("ftvim.core.builtins")
	--builtins.config()

	local settings = require("ftvim.config.settings")
	settings.load_defaults()
end

return M
