-- FtVim Editor Plugins

local icons = require "ftvim.icons"

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

return {
  -- Neo-tree (file explorer)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle reveal_force_cwd<cr>", desc = "Explorer" },
    },
    deactivate = function()
      vim.cmd [[Neotree close]]
    end,
    init = function()
      -- Load neo-tree if opening a directory
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          end
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require "neo-tree"
          end
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "notify" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none",
          ["l"] = "open",
          ["h"] = "close_node",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged = "󰱒",
          },
        },
      },
    },
  },

  -- Snacks.nvim (picker and utilities)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {
        enabled = true,
        sources = {
          files = {
            hidden = true,
          },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "i", "n" } },
            },
          },
        },
      },
      bigfile = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      indent = {
        enabled = true,
        scope = { enabled = true },
      },
      terminal = {
        win = { style = "terminal" },
      },
      dashboard = {
        enabled = true,
        preset = {
          header = logo,
          -- stylua: ignore
          keys = {
            { icon = icons.ui.FindFile, key = "f", desc = "Find File", action = function() Snacks.picker.files() end },
            { icon = icons.ui.NewFile, key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = icons.ui.History, key = "r", desc = "Recent Files", action = function() Snacks.picker.recent() end },
            { icon = icons.ui.FindText, key = "t", desc = "Find Text", action = function() Snacks.picker.grep() end },
            { icon = icons.ui.Gear, key = "c", desc = "Config", action = ":e $MYVIMRC | cd %:p:h" },
            { icon = icons.ui.Package, key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = icons.ui.SignOut, key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
          { text = { "ftvim.github.io", hl = "SnacksDashboardFooter" }, align = "center", padding = { 0, 1 } },
        },
      },
      quickfile = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
    -- stylua: ignore
    keys = {
      -- Find
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find File" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fs", function() Snacks.picker.grep() end, desc = "Find String" },
      { "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Find String Under Cursor" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>fC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>fH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>fM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>fR", function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>fl", function() Snacks.picker.resume() end, desc = "Resume Last Search" },
      -- Git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git Commits" },
      { "<leader>gC", function() Snacks.picker.git_log_file() end, desc = "Git Buffer Commits" },
      { "<leader>go", function() Snacks.picker.git_status() end, desc = "Git Status" },
      -- Notifications
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      -- Terminal: <C-\> float, <leader>th horizontal, <leader>tv vertical
      { "<C-\\>", function() Snacks.terminal.toggle(nil, { count = 1, win = { position = "float" } }) end, mode = { "n", "t" }, desc = "Toggle Terminal" },
      { "<leader>tf", function() Snacks.terminal.toggle(nil, { count = 1, win = { position = "float" } }) end, desc = "Float Terminal" },
      { "<leader>th", function() Snacks.terminal.toggle(nil, { count = 2, win = { position = "bottom", height = 0.3 } }) end, desc = "Horizontal Terminal" },
      { "<leader>tv", function() Snacks.terminal.toggle(nil, { count = 3, win = { position = "right", width = 0.4 } }) end, desc = "Vertical Terminal" },
    },
  },

  -- Which-key (keybinding hints)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      spec = {},
      plugins = {
        marks = false,
        registers = false,
        spelling = { enabled = true, suggestions = 20 },
        presets = {
          operators = false,
          motions = false,
          text_objects = false,
          windows = false,
          nav = false,
          z = false,
          g = false,
        },
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      win = {
        height = { min = 4, max = 25 },
      },
      layout = {
        width = { min = 20, max = 50 },
        spacing = 3,
      },
      show_help = true,
      show_keys = true,
      triggers = {
        { "<leader>", mode = { "n", "v" } },
      },
    },
    config = function(_, opts)
      local wk = require "which-key"
      -- FtVim defaults go first so specs from extras/users (opts.spec) can override them
      -- stylua: ignore
      table.insert(opts.spec, 1, {
        { "<leader>;", function() Snacks.dashboard() end, desc = "Dashboard" },
        { "<leader>/", "gcc", desc = "Comment Line", remap = true },
        { "<leader>F", group = "FtVim" },
        { "<leader>Fk", function() Snacks.picker.keymaps() end, desc = "View Keymappings" },
        { "<leader>Fx", "<cmd>FtVimExtras<cr>", desc = "Extras" },
        { "<leader>FH", "<cmd>checkhealth ftvim<cr>", desc = "Health Check" },
        { "<leader>T", group = "Treesitter" },
        { "<leader>Ti", "<cmd>TSConfigInfo<cr>", desc = "Info" },
        { "<leader>b", group = "Buffers" },
        { "<leader>bs", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by Directory" },
        { "<leader>bL", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by Language" },
        { "<leader>bW", "<cmd>noautocmd w<cr>", desc = "Save Without Formatting" },
        { "<leader>bb", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous" },
        { "<leader>be", "<cmd>BufferLinePickClose<cr>", desc = "Pick to Close" },
        { "<leader>bf", function() Snacks.picker.buffers() end, desc = "Find" },
        { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump" },
        { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next" },
        -- LSP mappings (<leader>ca, <leader>cr, ...) are buffer-local, set on LspAttach
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>fn", "<cmd>enew<cr>", desc = "New File" },
        { "<leader>g", group = "Git" },
        { "<leader>l", "<cmd>Lazy<cr>", desc = "Lazy" },
        { "<leader>p", group = "Plugins" },
        { "<leader>pS", "<cmd>Lazy clear<cr>", desc = "Clear" },
        { "<leader>pi", "<cmd>Lazy install<cr>", desc = "Install" },
        { "<leader>pl", "<cmd>Lazy<cr>", desc = "Lazy" },
        { "<leader>ps", "<cmd>Lazy sync<cr>", desc = "Sync" },
        { "<leader>pu", "<cmd>Lazy update<cr>", desc = "Update" },
        { "<leader>n", group = "Notifications" },
        { "<leader>q", group = "Quit" },
        { "<leader>t", group = "Terminal" },
        { "<leader>u", group = "UI" },
        { "<leader>qq", "<cmd>confirm q<cr>", desc = "Quit" },
        { "<leader>w", group = "Windows" },
        { "<leader>wd", "<cmd>q<cr>", desc = "Close Window" },
        { "<leader>ws", group = "Split" },
        { "<leader>wsh", "<cmd>split<cr>", desc = "Horizontal" },
        { "<leader>wsv", "<cmd>vsplit<cr>", desc = "Vertical" },
        { "<leader>ww", "<cmd>split new<cr>", desc = "New Window" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>xd", desc = "Toggle Diagnostics" },
        { "<leader>xl", "<cmd>lopen<cr>", desc = "Location List" },
        { "<leader>xq", "<cmd>copen<cr>", desc = "Quickfix List" },
        {
          mode = "v",
          { "<leader>/", "gc", desc = "Comment Selection", remap = true },
        },
      })
      wk.setup(opts)
    end,
  },

  -- Mini.ai (better text objects)
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = {
      -- Provides the @function/@class/... queries used below
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
    },
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter {
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          },
          f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" },
          c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" },
        },
      }
    end,
  },

  -- Mini.bufremove (better buffer deletion)
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "Delete Buffer (Force)",
      },
    },
  },
}
