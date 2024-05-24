return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = true,
    opts = {
        mode = "cursor",
        max_lines = 3,
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
    },
  },
}
