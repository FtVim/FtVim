local M = {}

local builtins = {
	"ftvim.core.which-key",
	"ftvim.core.gitsigns",
	"ftvim.core.cmp",
	"ftvim.core.terminal",
	"ftvim.core.telescope",
	"ftvim.core.treesitter",
	"ftvim.core.nvimtree",
	"ftvim.core.lir",
	"ftvim.core.illuminate",
	"ftvim.core.indentlines",
	"ftvim.core.project",
  	"ftvim.core.bufferline",
  	"ftvim.core.autopairs",
  	"ftvim.core.comment",
  	"ftvim.core.lualine",
  	"ftvim.core.alpha"
}

function M.config()
  for _, builtin_path in ipairs(builtins) do
    local builtin = reload(builtin_path)

    builtin.config()
  end
end

return M
