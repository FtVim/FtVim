local M = {}

local builtins = {
	"ftvim.core.theme",
	"ftvim.core.which-key",
	"ftvim.core.gitsigns",
	"ftvim.core.cmp",
	"ftvim.core.terminal",
	"ftvim.core.telescope",
	"ftvim.core.treesitter",
	"ftvim.core.nvimtree",
	"ftvim.core.lir",
	"ftvim.core.illuminate",
	"ftvim.core.indentscope",
	"ftvim.core.project",
	"ftvim.core.mini_bufremove",
	"ftvim.core.bufferline",
	"ftvim.core.autopairs",
	"ftvim.core.comment",
	"ftvim.core.lualine",
	"ftvim.core.persistence",
	"ftvim.core.mason",
	--"ftvim.core.lspconfig",
	"ftvim.core.alpha",
}

function M.config(config)
	for _, builtin_path in ipairs(builtins) do
		local builtin = reload(builtin_path)

		builtin.config(config)
	end
end

return M
