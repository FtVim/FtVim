return {
{
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
          options = {
            -- stylua: ignore
            close_command = function(n) require("mini.bufremove").delete(n, false) end,
            -- stylua: ignore
            right_mouse_command = function(n) require("mini.bufremove").delete(n, false) end,
            diagnostics = "nvim_lsp",
            always_show_bufferline = false,
            diagnostics_indicator = function(_, _, diag)
              local icons = require("ftvim.config").icons.diagnostics
              local ret = (diag.error and icons.Error .. diag.error .. " " or "")
                .. (diag.warning and icons.Warn .. diag.warning or "")
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
    }
}
