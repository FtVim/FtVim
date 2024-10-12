local M = {}

local defaults = {
  colorscheme = function()
    require("tokyonight").load()
  end,
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

return M
