-- FtVim Editor Plugins

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
      vim.cmd([[Neotree close]])
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
            require("neo-tree")
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
      -- Only enable picker for now, disable other features
      bigfile = { enabled = false },
      notifier = { enabled = false },
      quickfile = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
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
    },
  },

  -- Which-key (keybinding hints)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
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
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "center",
      },
      show_help = true,
      show_keys = true,
      triggers = { "<leader>" },
      disable = {
        buftypes = {},
        filetypes = {},
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>;", "<cmd>Alpha<cr>", desc = "Dashboard" },
        { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Comment Line" },
        { "<leader>F", group = "FtVim" },
        { "<leader>Fk", function() Snacks.picker.keymaps() end, desc = "View Keymappings" },
        { "<leader>T", group = "Treesitter" },
        { "<leader>Ti", "<cmd>TSConfigInfo<cr>", desc = "Info" },
        { "<leader>b", group = "Buffers" },
        { "<leader>bD", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by Directory" },
        { "<leader>bL", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by Language" },
        { "<leader>bW", "<cmd>noautocmd w<cr>", desc = "Save Without Formatting" },
        { "<leader>bb", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous" },
        {
          "<leader>bd",
          function()
            require("mini.bufremove").delete(0, false)
          end,
          desc = "Close Buffer",
        },
        { "<leader>be", "<cmd>BufferLinePickClose<cr>", desc = "Pick to Close" },
        { "<leader>bf", function() Snacks.picker.buffers() end, desc = "Find" },
        { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Close Left" },
        { "<leader>bj", "<cmd>BufferLinePick<cr>", desc = "Jump" },
        { "<leader>bl", "<cmd>BufferLineCloseRight<cr>", desc = "Close Right" },
        { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Next" },
        { "<leader>c", group = "Code" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
        { "<leader>cd", vim.lsp.buf.definition, desc = "Goto Definition" },
        { "<leader>ci", vim.lsp.buf.implementation, desc = "Goto Implementation" },
        { "<leader>cr", vim.lsp.buf.references, desc = "Goto References" },
        { "<leader>cs", vim.lsp.buf.signature_help, desc = "Signature Help" },
        { "<leader>ct", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
        { "<leader>cv", vim.lsp.buf.hover, desc = "Hover" },
        { "<leader>cx", vim.lsp.buf.rename, desc = "Rename" },
        { "<leader>cm", group = "Mason" },
        { "<leader>cmm", "<cmd>Mason<cr>", desc = "Mason" },
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
        { "<leader>q", group = "Quit" },
        { "<leader>qq", "<cmd>confirm q<cr>", desc = "Quit" },
        { "<leader>w", group = "Windows" },
        { "<leader>wd", "<cmd>q<cr>", desc = "Close Window" },
        { "<leader>ws", group = "Split" },
        { "<leader>wsh", "<cmd>split<cr>", desc = "Horizontal" },
        { "<leader>wsv", "<cmd>vsplit<cr>", desc = "Vertical" },
        { "<leader>ww", "<cmd>split new<cr>", desc = "New Window" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>xl", "<cmd>lopen<cr>", desc = "Location List" },
        { "<leader>xq", "<cmd>copen<cr>", desc = "Quickfix List" },
        {
          mode = "v",
          { "<leader>/", "<Plug>(comment_toggle_linewise_visual)", desc = "Comment Selection" },
        },
      })
    end,
  },

  -- Toggleterm (terminal)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
      { "<leader>th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal Terminal" },
      { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical Terminal" },
    },
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    },
  },

  -- Mini.ai (better text objects)
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
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
