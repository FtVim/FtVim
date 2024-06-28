local plugin_loader = {}
local utils = require "ftvim.utils"
local plugins_dir = join_paths(get_runtime_dir(), "site", "pack", "lazy", "opt")
local join_paths = utils.join_paths

function plugin_loader.load(configurations)
  local lazy_available, lazy = pcall(require, "lazy")
  if not lazy_available then
    return
  end

  -- remove plugins from rtp before loading lazy, so that all plugins won't be loaded on startup
  vim.opt.runtimepath:remove(join_paths(plugins_dir, "*"))
  local status_ok = xpcall(function()
    table.insert(ftvim.lazy.opts.install.colorscheme, 1, ftvim.colorscheme)
    lazy.setup(configurations, ftvim.lazy.opts)
  end, debug.traceback)

  if not status_ok then
  end
end

return plugin_loader
