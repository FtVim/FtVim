local plugin_loader = {}

function plugin_loader.load(configurations)

  local lazy_available, lazy = pcall(require, "lazy")

  if not lazy_available then


    return

  end



  -- remove plugins from rtp before loading lazy, so that all plugins won't be loaded on startup

  vim.opt.runtimepath:remove(join_paths(plugins_dir, "*"))



  local status_ok = xpcall(function()

    table.insert(lvim.lazy.opts.install.colorscheme, 1, lvim.colorscheme)

    lazy.setup(configurations, lvim.lazy.opts)

  end, debug.traceback)



  if not status_ok then


  end

end

return plugin_loader
