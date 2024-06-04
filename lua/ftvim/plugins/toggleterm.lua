return {
    {
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm" },
        config = require("toggleterm"),
        keys = {
            {
              "<leader>tv",
              function()
                local count = vim.v.count1
                require("toggleterm").toggle(count, 70, vim.loop.cwd(), "vertical")
              end,
              desc = "ToggleTerm (vertical)",
            },
            {
              "<leader>th",
              function()
                local count = vim.v.count1
                require("toggleterm").toggle(count, 15, vim.loop.cwd(), "horizontal")
              end,
              desc = "ToggleTerm (horizontal)",
            },
            {
              "<leader>tf",
              function()
                local count = vim.v.count1
                require("toggleterm").toggle(count, 5, vim.loop.cwd(), "float")
              end,
              desc = "ToggleTerm (floating)",
            },
        },
    }
}

