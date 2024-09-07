vim.uv = vim.uv or vim.loop

local M = {}

---@param opts? FtVimConfig
function M.setup(opts)
  require("ftvim.config").setup(opts)
end

return M
