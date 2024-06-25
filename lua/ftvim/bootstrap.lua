local M = {}

if vim.fn.has "nvim-0.10" ~= 1 then
  vim.notify("Please upgrade your Neovim base installation. Lunarvim requires v0.10+", vim.log.levels.WARN)
  vim.wait(5000, function()
    ---@diagnostic disable-next-line: redundant-return-value
    return false
  end)
  vim.cmd "cquit"
end

local uv = vim.loop
local path_sep = uv.os_uname().version:match "Windows" and "\\" or "/"

---Join path segments that were passed as input
---@return string
function _G.join_paths(...)
  local result = table.concat({ ... }, path_sep)
  return result
end

_G.require_clean = require("lvim.utils.modules").require_clean
_G.require_safe = require("lvim.utils.modules").require_safe
_G.reload = require("lvim.utils.modules").reload

---Get the full path to `$LUNARVIM_RUNTIME_DIR`
---@return string|nil
function _G.get_runtime_dir()
  local lvim_runtime_dir = os.getenv "LUNARVIM_RUNTIME_DIR"
  if not lvim_runtime_dir then
    -- when nvim is used directly
    return vim.call("stdpath", "data")
  end
  return lvim_runtime_dir
end

local M = {}

function M:init(base_dir)

  require("ftvim.config"):init()

  return self
end

return M
