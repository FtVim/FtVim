local M = {}

M.version = "2.0.0"

---@param opts? FtVimConfig
function M.setup(opts)
  require("ftvim.config").setup(opts)
end

return M
