---@class FtVimConfig
---@field colorscheme string|fun()
---@field icons table
---@field defaults table

local M = {}

---@type FtVimConfig
local defaults = {
  -- Colorscheme to use (string or function)
  colorscheme = "catppuccin",
  -- Icons used throughout FtVim
  icons = require("ftvim.icons"),
  -- Load default configs
  defaults = {
    autocmds = true,
    keymaps = true,
    options = true,
  },
}

---@type FtVimConfig
local options

---@param opts? FtVimConfig
function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {})

  -- Load autocmds
  if options.defaults.autocmds then
    M.load("autocmds")
  end

  -- Load keymaps
  if options.defaults.keymaps then
    M.load("keymaps")
  end

  -- Apply colorscheme
  vim.schedule(function()
    M.load_colorscheme()
  end)
end

---Load colorscheme with error handling
function M.load_colorscheme()
  local ok, err = pcall(function()
    if type(options.colorscheme) == "function" then
      options.colorscheme()
    else
      vim.cmd.colorscheme(options.colorscheme)
    end
  end)
  if not ok then
    vim.notify("Failed to load colorscheme: " .. tostring(err), vim.log.levels.ERROR)
    vim.cmd.colorscheme("habamax")
  end
end

---Load a config module (autocmds, keymaps, options)
---@param name "autocmds"|"keymaps"|"options"
function M.load(name)
  -- Load FtVim's config
  local ftvim_mod = "ftvim.config." .. name
  local ok, err = pcall(require, ftvim_mod)
  if not ok and not err:match("module.*not found") then
    vim.notify("Error loading " .. ftvim_mod .. ": " .. err, vim.log.levels.ERROR)
  end

  -- Load user's config (from lua/config/)
  local user_mod = "config." .. name
  ok, err = pcall(require, user_mod)
  if not ok and not err:match("module.*not found") then
    vim.notify("Error loading " .. user_mod .. ": " .. err, vim.log.levels.ERROR)
  end
end

M.did_init = false

---Initialize FtVim (called from plugins/init.lua)
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true

  -- Add FtVim to runtimepath if installed as a plugin
  local plugin = require("lazy.core.config").spec.plugins.FtVim
  if plugin then
    vim.opt.rtp:append(plugin.dir)
  end

  -- Load options early (before plugins)
  if defaults.defaults.options then
    M.load("options")
  end
end

-- Metatable for easy access to options
setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    return options[key]
  end,
})

return M
