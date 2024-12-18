local M = {}

local defaults = {
  colorscheme = "vogsphere",
  icons = require("ftvim.icons"),
}

local options

function M.setup(opts)
  options = vim.tbl_deep_extend("force", defaults, opts or {}) or {}
  M.load("autocmds")
  M.load("keymaps")
  require("lazy.core.util").track("colorscheme")
  require("lazy.core.util").try(function()
    if type(M.colorscheme) == "function" then
      M.colorscheme()
    else
      vim.cmd.colorscheme(M.colorscheme)
    end
  end, {
    msg = "Could not load your colorscheme",
    on_error = function(msg)
      require("lazy.core.util").error(msg)
      vim.cmd.colorscheme("default")
    end,
  })
  require("lazy.core.util").track()
end

function M.load(name)
  local function _load(mod)
    if require("lazy.core.cache").find(mod)[1] then
      require("lazy.core.util").try(function()
        require(mod)
      end, { msg = "Failed loading " .. mod })
    end
  end
  _load("ftvim.config." .. name)
  _load("config." .. name)
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true
  local plugin = require("lazy.core.config").spec.plugins.FtVim
  if plugin then
    vim.opt.rtp:append(plugin.dir)
  end
  M.load("options")
end

setmetatable(M, {
  __index = function(_, key)
    if options == nil then
      return vim.deepcopy(defaults)[key]
    end
    return options[key]
  end,
})

return M
