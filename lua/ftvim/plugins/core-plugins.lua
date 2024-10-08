return {
	{ "folke/lazy.nvim", tag = "stable" },

	-- live server
	{
		'barrett-ruth/live-server.nvim',
		config = function()
			require('live-server').setup(opts)
		end,
	},

	-- 42 Utils

	{
    "cacharle/c_formatter_42.vim",
    config = function()
      vim.api.nvim_set_keymap('n', "<leader>Ff", "<CMD>CFormatter42<CR>", { noremap = true, silent = true,
    })
  end
	},
	{
		"42Paris/42header",
		config = function() end,
	},
  {
    "TuTaRdrgZ/ft_count_lines.nvim",
    enabled = true,
    config = function()
      require("ft_count_lines").setup()
    end
  },

  -- Notify
  {
    "rcarriga/nvim-notify",
    event = "BufLeave",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss All Notifications",
      },
    },
    config = function()
      require("ftvim.core.notifications").setup()
    end,
  },

  -- Autocompletion

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", -- source for text in buffer
      "hrsh7th/cmp-path", -- source for file system paths
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      },
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
      "rafamadriz/friendly-snippets", -- useful snippets
      "onsails/lspkind.nvim", -- vs-code like pictograms
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      require("ftvim.core.cmp").setup()
    end,
    enabled = ftvim.builtin.cmp.active,
  },

  -- Mason and lsp

  {
    "williamboman/mason.nvim",
    config = function()
      require("ftvim.core.mason").setup()
    end,
    build = ":MasonUpdate",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("ftvim.core.mason").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim"
    },
    config = function()
      require("neodev").setup()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require("lspconfig")
      local lsp_available = function(server_name)
        local server_available, server = lspconfig.util.available_servers(server_name)
        return server_available
      end

      if lsp_available("lua_ls") then
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          filetypes = { "lua" }
        })
      end

      if lsp_available("clangd") then
        lspconfig.clangd.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = {
            "clangd",
            "--offset-encoding=utf-16",
          },
          autostart = false,
          filetypes = { "c", "cpp" }
        })
      end
      if lsp_available("pyright") then
        lspconfig.pyright.setup({
          capabilities = capabilities,
          filetypes = { "python" }
        })
      end
      if lsp_available("ts_ls") then
        lspconfig.ts_ls.setup({
          capabilities = capabilities,
          filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript" }
        })
      end

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },

  -- Themes

  {

    "folke/tokyonight.nvim",

    lazy = not vim.startswith(ftvim.colorscheme, "tokyonight"),
    config = function()
      require("tokyonight").setup(ftvim.builtin.theme.tokyonight.options)
    end,
  },
  {
    "rebelot/kanagawa.nvim",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },

  -- Telescope

  {

    "nvim-telescope/telescope.nvim",

    branch = "0.1.x",

    config = function()
      require("ftvim.core.telescope").setup()
    end,

    dependencies = { "telescope-fzf-native.nvim" },

    lazy = true,

    cmd = "Telescope",

    enabled = ftvim.builtin.telescope.active,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    lazy = true,
    enabled = ftvim.builtin.telescope.active,
  },

  -- Install nvim-cmp, and buffer source as a dependency

  {

    "hrsh7th/cmp-cmdline",

    lazy = true,
  },

  -- Autopairs

  {

    "windwp/nvim-autopairs",

    event = "InsertEnter",

    config = function()
      require("ftvim.core.autopairs").setup()
    end,

    enabled = ftvim.builtin.autopairs.active,

    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
  },

  -- Treesitter

  {

    "nvim-treesitter/nvim-treesitter",

    -- run = ":TSUpdate",

    config = function()
      local utils = require("ftvim.utils")

      local path = utils.join_paths(get_runtime_dir(), "site", "pack", "lazy", "opt", "nvim-treesitter")

      vim.opt.rtp:prepend(path) -- treesitter needs to be before nvim's runtime in rtp

      require("ftvim.core.treesitter").setup()
    end,

    cmd = {

      "TSInstall",

      "TSUninstall",

      "TSUpdate",

      "TSUpdateSync",

      "TSInstallInfo",

      "TSInstallSync",

      "TSInstallFromGrammar",
    },

    event = "User FileOpened",
  },

  -- NvimTree

  {

    "nvim-tree/nvim-tree.lua",

    config = function()
      require("ftvim.core.nvimtree").setup()
    end,

    enabled = ftvim.builtin.nvimtree.active,

    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },

    event = "User DirOpened",
  },

  -- Lir

  {

    "tamago324/lir.nvim",

    config = function()
      require("ftvim.core.lir").setup()
    end,

    enabled = ftvim.builtin.lir.active,

    event = "User DirOpened",
  },

  {

    "lewis6991/gitsigns.nvim",

    config = function()
      require("ftvim.core.gitsigns").setup()
    end,

    event = "User FileOpened",

    cmd = "Gitsigns",

    enabled = ftvim.builtin.gitsigns.active,
  },

  -- Whichkey

  {

    "folke/which-key.nvim",

    config = function()
      require("ftvim.core.which-key").setup()
    end,

    cmd = "WhichKey",

    event = "VeryLazy",

    enabled = ftvim.builtin.which_key.active,
  },

  -- Comments

  {

    "numToStr/Comment.nvim",

    config = function()
      require("ftvim.core.comment").setup()
    end,

    keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },

    event = "VimEnter",

    enabled = ftvim.builtin.comment.active,
  },

  -- project.nvim

  {

    "ahmedkhalf/project.nvim",

    config = function()
      require("ftvim.core.project").setup()
    end,

    enabled = ftvim.builtin.project.active,

    event = "VimEnter",

    cmd = "Telescope projects",
  },

  -- Icons

  {

    "nvim-tree/nvim-web-devicons",

    enabled = ftvim.use_icons,

    lazy = true,
  },

  -- Status Line and Bufferline && mini-bufremove

  {

    -- "hoob3rt/lualine.nvim",

    "nvim-lualine/lualine.nvim",

    config = function()
      require("ftvim.core.lualine").setup()
    end,

    event = "VimEnter",

    enabled = ftvim.builtin.lualine.active,
  },

  {

    "akinsho/bufferline.nvim",

    config = function()
      require("ftvim.core.bufferline").setup()
    end,

    branch = "main",

    event = "VimEnter",

    enabled = ftvim.builtin.bufferline.active,
  },

  {
    "echasnovski/mini.bufremove",

    branch = "main",

    config = function()
      require("ftvim.core.mini_bufremove").setup()
    end,

    enabled = ftvim.builtin.mini_bufremove.active,
  },

  -- alpha

  {

    "goolord/alpha-nvim",

    config = function()
      require("ftvim.core.alpha").setup()
    end,

    enabled = ftvim.builtin.alpha.active,

    event = "VimEnter",
  },

  -- Terminal

  {

    "akinsho/toggleterm.nvim",

    branch = "main",

    init = function()
      require("ftvim.core.terminal").init()
    end,

    config = function()
      require("ftvim.core.terminal").setup()
    end,

    cmd = {

      "ToggleTerm",

      "TermExec",

      "ToggleTermToggleAll",

      "ToggleTermSendCurrentLine",

      "ToggleTermSendVisualLines",

      "ToggleTermSendVisualSelection",
    },

    keys = ftvim.builtin.terminal.open_mapping,

    enabled = ftvim.builtin.terminal.active,
  },

  -- Better UI

  {

    "RRethy/vim-illuminate",

    config = function()
      require("ftvim.core.illuminate").setup()
    end,

    event = "VimEnter",

    enabled = ftvim.builtin.illuminate.active,
  },

  {

    "lukas-reineke/indent-blankline.nvim",

    main = "ibl",

    config = function()
      require("ibl").setup()
    end,
    opts = {},
  },

  {
    "echasnovski/mini.indentscope",
    version = false,
    config = function()
      require("ftvim.core.indentscope").setup()
    end,
    enabled = ftvim.builtin.indentscope.active,
  },

  {
    "stevearc/dressing.nvim",
    opts = {},
  },

  -- Session management

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("ftvim.core.persistence").setup()
    end,
    enabled = ftvim.builtin.persistence.active,
    -- library used by other plugins
    { "nvim-lua/plenary.nvim", lazy = true },
  },

  -- Search and replace

  {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
    },
  },

  -- Copilot

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("ftvim.core.copilot").setup()
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
}
