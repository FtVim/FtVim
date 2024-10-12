local M = {}

local defaults = {
  colorscheme = "vogsphere",
  defaults = {
    autocmds = true,
    keymaps = true,
  },
  icons = {
    misc = {
      dots = "󰇘",
    },
    ft = {
      octo = "",
    },
    git = {
      added    = " ",
      modified = " ",
      removed  = " ",
    },
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Codeium       = "󰘦 ",
      Color         = " ",
      Control       = " ",
      Collapsed     = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Copilot       = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Keyword       = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = " ",
      String        = " ",
      Struct        = "󰆼 ",
      TabNine       = "󰏚 ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = " ",
    },
  },
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
  if M.defaults[name] or name == "options" then
    _load("ftvim.config." .. name)
  end
  _load("config." .. name)
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true
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
