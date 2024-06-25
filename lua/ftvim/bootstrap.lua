local M = {}

function M:init(base_dir)
  require("ftvim.config"):init()
  return self
end

return M
