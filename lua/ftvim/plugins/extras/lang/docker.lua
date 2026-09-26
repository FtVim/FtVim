-- FtVim Docker Extra (Inception)
-- Enable with: { import = "ftvim.plugins.extras.lang.docker" }
--
-- This extra includes:
-- - Treesitter: dockerfile, yaml and nginx parsers
-- - LSP: dockerls, docker_compose_language_service and yamlls
-- - Linting: hadolint for Dockerfiles

-- docker_compose_language_service only attaches to the "yaml.docker-compose" filetype
vim.filetype.add {
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
}
vim.treesitter.language.register("yaml", "yaml.docker-compose")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "dockerfile", "yaml", "nginx" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
        yamlls = {},
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "hadolint" },
    },
  },
}
