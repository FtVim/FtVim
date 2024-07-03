local plugin_loader = {}
local utils = require "ftvim.utils"
local join_paths = utils.join_paths
local plugins_dir = join_paths(get_runtime_dir(), "site", "pack", "lazy", "opt")

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
    print("Failed to setup lazy.nvim")
  end

  -- Instalar plugins si no están instalados
  local install_status = lazy.install()
  if not install_status then
    print("Failed to install plugins")
  end
end

return plugin_loader
