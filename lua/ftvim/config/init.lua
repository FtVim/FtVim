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
  icons = require "ftvim.icons",
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

  M.load("autocmds", options.defaults.autocmds)
  M.load("keymaps", options.defaults.keymaps)

  vim.api.nvim_create_user_command("FtVimExtras", function()
    require("ftvim.extras").show()
  end, { desc = "Enable/disable FtVim extras" })

  local colorscheme_before = vim.g.colors_name
  vim.schedule(function()
    local user_set_colorscheme = options.colorscheme ~= defaults.colorscheme
    local changed_externally = vim.g.colors_name ~= colorscheme_before

    if changed_externally and not user_set_colorscheme then
      return
    end

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
    vim.cmd.colorscheme "habamax"
  end
end

---Load a config module (autocmds, keymaps, options)
---The user's module (lua/config/<name>.lua) is always loaded, even when FtVim's defaults are disabled.
---@param name "autocmds"|"keymaps"|"options"
---@param load_defaults? boolean Load FtVim's defaults for this module (default: true)
function M.load(name, load_defaults)
  local mods = { "config." .. name }
  if load_defaults ~= false then
    table.insert(mods, 1, "ftvim.config." .. name)
  end
  for _, mod in ipairs(mods) do
    -- Only require modules that exist, so errors inside them are never mistaken for "not found"
    if #vim.loader.find(mod) > 0 then
      local ok, err = pcall(require, mod)
      if not ok then
        vim.notify("Error loading " .. mod .. ": " .. err, vim.log.levels.ERROR)
      end
    end
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

  -- Load options early (before plugins). setup() hasn't run yet, so read the user's
  -- `defaults.options` straight from the FtVim spec.
  local load_options = true
  if plugin then
    local ok, opts = pcall(require("lazy.core.plugin").values, plugin, "opts", false)
    if ok and vim.tbl_get(opts or {}, "defaults", "options") == false then
      load_options = false
    end
  end
  M.load("options", load_options)
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
