-- FtVim UI Plugins

local icons = require "ftvim.icons"

return {
  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
      },
    },
  },

  -- Mini.indentscope (animated scope indicator)
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require "alpha.themes.dashboard"

      local function footer()
        local stats = require("lazy").stats()
        local plugins_count = stats.loaded
        local datetime = os.date "  %m-%d-%Y   %H:%M:%S"
        local version = vim.version()
        local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
        return datetime .. "   Plugins " .. plugins_count .. nvim_version_info
      end

      local logo = [[
    ███████████ ███████████ █████   █████ █████ ██████   ██████
   ░░███░░░░░░█░█░░░███░░░█░░███   ░░███ ░░███ ░░██████ ██████ 
    ░███   █ ░ ░   ░███  ░  ░███    ░███  ░███  ░███░█████░███ 
    ░███████       ░███     ░███    ░███  ░███  ░███░░███ ░███ 
    ░███░░░█       ░███     ░░███   ███   ░███  ░███ ░░░  ░███ 
    ░███  ░        ░███      ░░░█████░    ░███  ░███      ░███ 
    █████          █████       ░░███      █████ █████     █████
   ░░░░░          ░░░░░         ░░░      ░░░░░ ░░░░░     ░░░░░  
      ]]

      dashboard.section.header.val = vim.split(logo, "\n")

      -- stylua: ignore
      dashboard.section.buttons.val = {
        dashboard.button("f", icons.ui.FindFile .. "  Find file",       "<cmd>lua Snacks.picker.files()<cr>"),
        dashboard.button("n", icons.ui.NewFile .. "  New file",        "<cmd>ene <BAR> startinsert<cr>"),
        dashboard.button("r", icons.ui.History .. "  Recent files",    "<cmd>lua Snacks.picker.recent()<cr>"),
        dashboard.button("t", icons.ui.FindText .. "  Find Text", "<cmd>lua Snacks.picker.grep()<cr>"),
        dashboard.button("c", icons.ui.Gear .. "  Config",          "<cmd>e $MYVIMRC | cd %:p:h<cr>"),
        dashboard.button("l", icons.ui.Package .. "  Lazy",            "<cmd>Lazy<cr>"),
        dashboard.button("q", icons.ui.SignOut .. "  Quit",            "<cmd>qa<cr>"),
      }

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end

      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8

      -- Create a separate section for the website link
      dashboard.section.website = {
        type = "text",
        val = "ftvim.github.io",
        opts = {
          position = "center",
          hl = "AlphaFooter",
        },
      }

      -- Set initial footer
      dashboard.section.footer.val = footer()

      -- Modify layout to include website as separate centered section
      dashboard.opts.layout = {
        { type = "padding", val = 8 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
        { type = "padding", val = 1 },
        dashboard.section.website,
      }

      return dashboard
    end,
    config = function(_, dashboard)
      -- Close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      -- Update footer with accurate stats after startup
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          local datetime = os.date "  %m-%d-%Y   %H:%M:%S"
          local version = vim.version()
          local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
          dashboard.section.footer.val = datetime
            .. "   Plugins "
            .. stats.loaded
            .. nvim_version_info
            .. "  ⚡"
            .. ms
            .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle Pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete Other Buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete Buffers to the Left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move Buffer Prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move Buffer Next" },
    },
    opts = {
      options = {
        mode = "buffers",
        close_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        diagnostics_indicator = function(_, _, diag)
          local ret = (diag.error and icons.diagnostics.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.diagnostics.Warning .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            local ok, bufferline = pcall(require, "bufferline")
            if ok and #vim.fn.getbufinfo { buflisted = 1 } > 1 then
              pcall(bufferline.sort_by, "id")
            end
          end)
        end,
      })
    end,
  },

  -- Illuminate (highlight word under cursor)
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- Also set it after loading ftplugins
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss { silent = true, pending = true }
        end,
        desc = "Dismiss All Notifications",
      },
    },
    opts = {
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      vim.notify = function(...)
        return require "notify"(...)
      end
    end,
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Dressing.nvim (better vim.ui)
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },

  -- Lualine (statusline)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- Set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- Hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local lualine_require = require "lualine_require"
      lualine_require.require = require

      vim.o.laststatus = vim.g.lualine_laststatus

      -- FtVim lualine colors
      local colors = {
        bg = "#202328",
        fg = "#bbc2cf",
        yellow = "#ECBE7B",
        cyan = "#008080",
        darkblue = "#081633",
        green = "#98be65",
        orange = "#FF8800",
        violet = "#a9a1e1",
        magenta = "#c678dd",
        purple = "#c678dd",
        blue = "#51afef",
        red = "#ec5f67",
      }

      local window_width_limit = 100

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand "%:t") ~= 1
        end,
        hide_in_width = function()
          return vim.o.columns > window_width_limit
        end,
      }

      -- Diff source from gitsigns
      local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end

      -- FtVim lualine components
      local components = {
        mode = {
          function()
            return " " .. icons.ui.FtVim .. " "
          end,
          padding = { left = 0, right = 0 },
          color = {},
          cond = nil,
        },
        diff = {
          "diff",
          source = diff_source,
          symbols = {
            added = icons.git.LineAdded .. " ",
            modified = icons.git.LineModified .. " ",
            removed = icons.git.LineRemoved .. " ",
          },
          padding = { left = 2, right = 1 },
          diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed = { fg = colors.red },
          },
          cond = nil,
        },
        python_env = {
          function()
            if vim.bo.filetype == "python" then
              local venv = os.getenv "CONDA_DEFAULT_ENV" or os.getenv "VIRTUAL_ENV"
              if venv then
                local ok, devicons = pcall(require, "nvim-web-devicons")
                if ok then
                  local py_icon, _ = devicons.get_icon ".py"
                  if py_icon then
                    -- Extract just the env name from path
                    local env_name = venv:match "([^/\\]+)$" or venv
                    return string.format(" " .. py_icon .. " (%s)", env_name)
                  end
                end
              end
            end
            return ""
          end,
          color = { fg = colors.green },
          cond = conditions.hide_in_width,
        },
        diagnostics = {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = {
            error = icons.diagnostics.BoldError .. " ",
            warn = icons.diagnostics.BoldWarning .. " ",
            info = icons.diagnostics.BoldInformation .. " ",
            hint = icons.diagnostics.BoldHint .. " ",
          },
        },
        treesitter = {
          function()
            return icons.ui.Tree
          end,
          color = function()
            local buf = vim.api.nvim_get_current_buf()
            local ts = vim.treesitter.highlighter.active[buf]
            return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
          end,
          cond = conditions.hide_in_width,
        },
        lsp = {
          function()
            local buf_clients = vim.lsp.get_clients { bufnr = 0 }
            if #buf_clients == 0 then
              return "LSP Inactive"
            end

            local buf_client_names = {}
            local copilot_active = false

            for _, client in pairs(buf_clients) do
              if client.name ~= "null-ls" and client.name ~= "copilot" then
                table.insert(buf_client_names, client.name)
              end
              if client.name == "copilot" then
                copilot_active = true
              end
            end

            local unique_client_names = table.concat(buf_client_names, ", ")
            local language_servers = string.format("[%s]", unique_client_names)

            if copilot_active then
              language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.git.Octoface .. "%*"
            end

            return language_servers
          end,
          color = { gui = "bold" },
          cond = conditions.hide_in_width,
        },
        location = { "location" },
        progress = {
          "progress",
          fmt = function()
            return "%P/%L"
          end,
          color = {},
        },
        spaces = {
          function()
            local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
            return icons.ui.Tab .. " " .. shiftwidth
          end,
          padding = 1,
        },
        encoding = {
          "o:encoding",
          fmt = string.upper,
          color = {},
          cond = conditions.hide_in_width,
        },
        filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } },
        scrollbar = {
          function()
            local current_line = vim.fn.line "."
            local total_lines = vim.fn.line "$"
            local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
            local line_ratio = current_line / total_lines
            local index = math.ceil(line_ratio * #chars)
            return chars[index]
          end,
          padding = { left = 0, right = 0 },
          color = "SLProgress",
          cond = nil,
        },
      }

      local opts = {
        options = {
          theme = "auto",
          globalstatus = true,
          icons_enabled = true,
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
        },
        sections = {
          lualine_a = {
            components.mode,
            "mode",
          },
          lualine_b = {
            "branch",
          },
          lualine_c = {
            components.diff,
            components.python_env,
          },
          lualine_x = {
            components.diagnostics,
            components.lsp,
            components.filetype,
          },
          lualine_y = { components.location },
          lualine_z = {
            components.progress,
          },
        },
        inactive_sections = {
          lualine_a = {
            components.mode,
          },
          lualine_b = {},
          lualine_c = {
            components.diff,
          },
          lualine_x = {
            components.diagnostics,
            components.filetype,
          },
          lualine_y = { components.location },
          lualine_z = {
            components.progress,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }

      return opts
    end,
  },
}
