return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
        [[                                                  ]],
        [[     ███████╗████████╗██╗   ██╗██╗███╗   ███╗     ]],
        [[     ██╔════╝╚══██╔══╝██║   ██║██║████╗ ████║     ]],
        [[     █████╗     ██║   ██║   ██║██║██╔████╔██║     ]],
        [[     ██╔══╝     ██║   ╚██╗ ██╔╝██║██║╚██╔╝██║     ]],
        [[     ██║        ██║    ╚████╔╝ ██║██║ ╚═╝ ██║     ]],
        [[     ╚═╝        ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝     ]],
        [[                                                  ]],
    }
    -- Set menu
    dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file",       "<cmd> Telescope find_files <cr>"),
        dashboard.button("n", " " .. " New file",        "<cmd> ene <BAR> startinsert <cr>"),
        dashboard.button("r", " " .. " Recent files",    "<cmd> Telescope oldfiles <cr>"),
        dashboard.button("g", " " .. " Find text",       "<cmd> Telescope live_grep <cr>"),
        dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
        dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
        dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
    }
    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
--    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
