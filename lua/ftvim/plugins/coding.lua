-- FtVim Coding Plugins

return {
  -- Blink.cmp (completion)
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
      },
      enabled = function()
        -- vim.g.ftvim_completion = false disables completion globally (used by exam mode)
        if vim.g.ftvim_completion == false or vim.b.ftvim_completion == false then
          return false
        end
        local disabled_filetypes = { "snacks_picker_input", "neo-tree-popup" }
        return not vim.tbl_contains(disabled_filetypes, vim.bo.filetype)
      end,
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = { enabled = true },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      -- LSP servers to install and configure
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              codeLens = { enable = true },
              completion = { callSnippet = "Replace" },
              doc = { privateName = { "^_" } },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders=1",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
      },
      -- Additional setup for servers
      setup = {},
    },
    config = function(_, opts)
      -- Setup keymaps when LSP attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("ftvim_lsp_attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client then
            require("ftvim.lsp.keymaps").on_attach(client, event.buf)
          end
        end,
      })

      -- Setup servers
      local servers = opts.servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Add blink.cmp capabilities if available
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      local have_mason, mlsp = pcall(require, "mason-lspconfig")

      ---Configure a server. Returns true if it should be enabled by FtVim/mason.
      ---@return boolean
      local function setup_server(server)
        local server_opts = servers[server] == true and {} or servers[server]
        server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, server_opts)
        server_opts.mason = nil

        -- Allow custom setup handlers (return true to skip the default setup)
        local custom = opts.setup[server] or opts.setup["*"]
        if custom and custom(server, server_opts) then
          return false
        end

        vim.lsp.config(server, server_opts)
        return true
      end

      local ensure_installed = {} ---@type string[]
      local exclude = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          local use_mason = have_mason and (server_opts == true or server_opts.mason ~= false)
          if not setup_server(server) then
            exclude[#exclude + 1] = server
          elseif use_mason then
            ensure_installed[#ensure_installed + 1] = server
          else
            vim.lsp.enable(server)
          end
        end
      end

      -- mason-lspconfig enables installed servers (and newly installed ones) via vim.lsp.enable()
      if have_mason then
        mlsp.setup {
          ensure_installed = ensure_installed,
          automatic_enable = { exclude = exclude },
        }
      end
    end,
  },

  -- Mason (LSP/DAP/Linter/Formatter installer)
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local ok, p = pcall(mr.get_package, tool)
          if not ok then
            vim.notify("Mason: unknown package " .. tool, vim.log.levels.WARN)
          elseif not p:is_installed() and not p:is_installing() then
            p:install()
          end
        end
      end)
    end,
  },

  -- Lazydev (Lua development)
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },

  -- Conform (formatting)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format { async = true, lsp_format = "fallback" }
        end,
        mode = { "n", "v" },
        desc = "Format",
      },
      {
        "<leader>uf",
        function()
          vim.g.ftvim_autoformat = not vim.g.ftvim_autoformat
          vim.notify("Format on save " .. (vim.g.ftvim_autoformat and "enabled" or "disabled"))
        end,
        desc = "Toggle Format on Save",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
      },
      -- Disabled by default. Enable with `vim.g.ftvim_autoformat = true` (or per buffer with
      -- `vim.b.ftvim_autoformat`), or toggle it with <leader>uf
      format_on_save = function(buf)
        local enabled = vim.b[buf].ftvim_autoformat
        if enabled == nil then
          enabled = vim.g.ftvim_autoformat
        end
        if enabled then
          return { timeout_ms = 1000, lsp_format = "fallback" }
        end
      end,
    },
  },

  -- nvim-lint (linting). Extras add linters with `opts.linters_by_ft` and `opts.linters`
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    opts = {
      -- Events that trigger linting
      events = { "BufReadPost", "BufWritePost", "InsertLeave" },
      ---@type table<string, string[]>
      linters_by_ft = {},
      -- Linter definitions or overrides (a table is merged into the existing linter)
      ---@type table<string, table|fun():table>
      linters = {},
    },
    config = function(_, opts)
      local lint = require "lint"
      for name, linter in pairs(opts.linters) do
        if type(linter) == "table" and type(lint.linters[name]) == "table" then
          lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      -- Debounced: bursts of events lint once, and the first BufReadPost runs after the filetype is set
      local timer = assert(vim.uv.new_timer())
      local function try_lint()
        timer:start(100, 0, function()
          vim.schedule(function()
            -- vim.g.ftvim_lint = false disables linting globally (used by exam mode)
            if vim.g.ftvim_lint ~= false then
              lint.try_lint()
            end
          end)
        end)
      end
      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("ftvim_lint", { clear = true }),
        callback = try_lint,
      })
      try_lint()
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      disable_filetype = { "snacks_picker_input" },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0,
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
  },
}
