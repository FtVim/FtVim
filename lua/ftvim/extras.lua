-- :FtVimExtras - enable/disable extras without editing your config.
-- The selection is stored in stdpath("config")/ftvim.json and imported by ftvim.plugins.xtras.

local M = {}

M.prefix = "ftvim.plugins.extras."

---@return string
function M.file()
  return vim.fn.stdpath "config" .. "/ftvim.json"
end

---@return { extras: string[] }
function M.read()
  local file = M.file()
  if vim.uv.fs_stat(file) then
    local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(file), "\n"))
    if ok and type(data) == "table" then
      data.extras = type(data.extras) == "table" and data.extras or {}
      return data
    end
    vim.notify("FtVim: could not parse " .. file, vim.log.levels.ERROR)
  end
  return { extras = {} }
end

---@param data { extras: string[] }
function M.write(data)
  table.sort(data.extras)
  vim.fn.writefile({ vim.json.encode(data) }, M.file())
end

---@class FtVimExtra
---@field module string
---@field name string
---@field desc string
---@field enabled boolean selected in ftvim.json
---@field imported boolean imported by the user's spec (can't be toggled here)

---@return FtVimExtra[]
function M.list()
  local root = require("ftvim.util").root() .. "/lua/"
  local selected = {}
  for _, module in ipairs(M.read().extras) do
    selected[module] = true
  end
  local imported = {}
  local ok, Config = pcall(require, "lazy.core.config")
  for _, module in ipairs(ok and Config.spec and Config.spec.modules or {}) do
    imported[module] = true
  end

  local extras = {} ---@type FtVimExtra[]
  local files = vim.fs.find(function(name)
    return name:match "%.lua$"
  end, { path = root .. "ftvim/plugins/extras", limit = math.huge, type = "file" })
  for _, file in ipairs(files) do
    local module = file:sub(#root + 1):gsub("%.lua$", ""):gsub("/", ".")
    local first = vim.fn.readfile(file, "", 1)[1] or ""
    extras[#extras + 1] = {
      module = module,
      name = module:sub(#M.prefix + 1),
      desc = first:gsub("^%-%-%s*FtVim%s*", ""),
      enabled = selected[module] == true,
      imported = imported[module] == true and not selected[module],
    }
  end
  table.sort(extras, function(a, b)
    return a.name < b.name
  end)
  return extras
end

---@param module string
function M.toggle(module)
  local data = M.read()
  local index = vim.tbl_contains(data.extras, module) and vim.fn.index(data.extras, module) + 1 or nil
  if index then
    table.remove(data.extras, index)
  else
    data.extras[#data.extras + 1] = module
  end
  M.write(data)
  vim.notify(
    ("%s %s. Restart Neovim to apply."):format(module:sub(#M.prefix + 1), index and "disabled" or "enabled"),
    vim.log.levels.INFO,
    { title = "FtVim Extras" }
  )
end

function M.show()
  vim.ui.select(M.list(), {
    prompt = "FtVim Extras (select to toggle)",
    ---@param extra FtVimExtra
    format_item = function(extra)
      local mark = (extra.enabled or extra.imported) and "●" or "○"
      local note = extra.imported and " (in your config)" or ""
      return ("%s %-12s %s%s"):format(mark, extra.name, extra.desc, note)
    end,
  }, function(extra)
    if not extra then
      return
    end
    if extra.imported then
      vim.notify(extra.name .. " is imported in your config. Remove it there to disable it.", vim.log.levels.WARN)
      return
    end
    M.toggle(extra.module)
    vim.schedule(M.show)
  end)
end

return M
