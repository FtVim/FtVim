-- FtVim UI Plugins

local icons = require "ftvim.icons"

return {
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

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
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
          -- Highlight groups (instead of fixed colors) so it follows the colorscheme
          diff_color = {
            added = "Added",
            modified = "Changed",
            removed = "Removed",
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
          color = "String",
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
              language_servers = language_servers .. " " .. icons.git.Octoface
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
        filetype = { "filetype", cond = nil, padding = { left = 1, right = 1 } },
      }

      local opts = {
        options = {
          theme = "auto",
          globalstatus = true,
          icons_enabled = true,
          component_separators = { left = "|", right = "|" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "snacks_dashboard" } },
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
