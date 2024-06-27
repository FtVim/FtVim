local M = {}

local builtins = {
	"ftvim.core.which-key"
}

function M.config()
  for _, builtin_path in ipairs(builtins) do
    local builtin = reload(builtin_path)

    builtin.config()
  end
end

return M
