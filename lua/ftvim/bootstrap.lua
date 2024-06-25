local M = {}

function M:init()
  ftvim = vim.deepcopy(require "ftvim.config.defaults")
  require("ftvim.config"):init()
  return self
end

return M
