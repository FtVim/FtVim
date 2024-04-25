return {
    {
        "akinsho/toggleterm.nvim",
        version = "*"
        cmd = { "ToggleTerm" },
        keys = {
            {
              "<leader>tv",
              function()
                local count = vim.v.count1
                require("toggleterm").toggle(count, 10, vim.loop.cwd(), "vertical")
              end,
              desc = "ToggleTerm (vertical)",
            },
            {
              "<leader>th",
              function()
                local count = vim.v.count1
                require("toggleterm").toggle(count, 10, vim.loop.cwd(), "horizontal")
              end,
              desc = "ToggleTerm (horizontal)",
            },
            {
              "<leader>tf",
              function()
                local count = vim.v.count1
                require("toggleterm").toggle(count, 10, vim.loop.cwd(), "float")
              end,
              desc = "ToggleTerm (floating)",
            },            {
              "<leader>tt",
              function()
                local count = vim.v.count1
                require("toggleterm").toggle(count, 10, vim.loop.cwd(), "tab")
              end,
              desc = "ToggleTerm (tab)",
            },
            opts = {
                -- size can be a number or function which is passed the current terminal
                size = function(term)
                    if term.direction == "horizontal" then
                        return 15
                    elseif term.direction == "vertical" then
                        return vim.o.columns * 0.4
                    end
                end,
                open_mapping = [[<c-\>]],
                hide_numbers = true, -- hide the number column in toggleterm buffers
                shade_filetypes = {},
                shade_terminals = true,
                start_in_insert = true,
                insert_mappings = true, -- whether or not the open mapping applies in insert mode
                terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
                persist_size = true,
                direction = "horizontal" or "vertical" or "window" or "float",
                close_on_exit = true, -- close the terminal window when the process exits
            },
        },
    }
}
