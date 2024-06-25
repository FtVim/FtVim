local M = {}

function M:init()
	local settings = require("ftvim.config.settings")
	settings.load_defaults()
end

return M
