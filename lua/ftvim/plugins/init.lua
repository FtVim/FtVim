-- FtVim Core Plugins
-- This file is loaded first and initializes FtVim

if vim.fn.has("nvim-0.10.0") == 0 then
  vim.api.nvim_echo({
    { "FtVim requires Neovim >= 0.10.0\n", "ErrorMsg" },
    { "Please upgrade Neovim to use FtVim\n", "WarningMsg" },
    { "Press any key to exit", "MoreMsg" },
  }, true, {})
  vim.fn.getchar()
  vim.cmd([[quit]])
  return {}
end

-- Initialize FtVim config
require("ftvim.config").init()

return {
  -- Lazy.nvim manages itself
  { "folke/lazy.nvim", version = "*" },

  -- FtVim as a plugin
  {
    "FtVim/FtVim",
    priority = 10000,
    lazy = false,
    cond = true,
    version = "*",
    opts = {},
  },

  -- Plenary (utility library used by many plugins)
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Treesitter (syntax highlighting, text objects, etc.)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- Stable API
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp early for other plugins
      require("lazy.core.loader").add_to_rtp(plugin)
      pcall(require, "nvim-treesitter.query_predicates")
    end,
    opts_extend = { "ensure_installed" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "lua",
        "markdown",
        "python",
        "vim",
        "vimdoc",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
