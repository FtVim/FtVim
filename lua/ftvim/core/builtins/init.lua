local M = {}

local builtins = {
	"ftvim.core.which-key",
	"ftvim.core.gitsigns",
	"ftvim.core.cmp",
	"ftvim.core.terminal",
	"ftvim.core.telescope",
	"ftvim.core.treesitter",
	"ftvim.core.nvimtree",
	"ftvim.core.project",
	"ftvim.core.lir",
	"ftvim.core.illuminate",
	"ftvim.core.indentlines",
	"ftvim.core.bufferline",
}

function M.config()
	for _, builtin_path in ipairs(builtins) do
		local builtin = require(builtin_path)

		builtin.config()
	end
end

return M
