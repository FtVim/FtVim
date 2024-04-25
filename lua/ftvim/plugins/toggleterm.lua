return {
    {
        "akinsho/toggleterm.nvim",
        cmd = { "ToggleTerm" },
        keys = {
            {
              "<leader>tv",
              function()
                local count = vim.v.count1
                require("toggleterm").toggle(count, 0, vim.loop.cwd(), "vertical")
              end,
              desc = "ToggleTerm (vertical)",
              size = 15,
            },
            {
              "<leader>th",
              function()
                local count = vim.v.count1
                require("toggleterm").toggle(count, 10, vim.loop.cwd(), "horizontal")
              end,
              desc = "ToggleTerm (horizontal)",
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
