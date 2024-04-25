return {
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {
            {
                -- size can be a number or function which is passed the current terminal
                size = 20 | function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
                end,
                open_mapping = [[<c-\>]], -- or { [[<c-\>]], [[<c-¥>]] } if you also use a Japanese keyboard.
                on_create = fun(t: Terminal), -- function to run when the terminal is first created
                on_open = fun(t: Terminal), -- function to run when the terminal opens
                on_close = fun(t: Terminal), -- function to run when the terminal closes
                on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
                on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
                on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
                hide_numbers = true, -- hide the number column in toggleterm buffers
                shade_filetypes = {},
                autochdir = false,
                persist_size = true,
                persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
                direction = 'horizontal'
                close_on_exit = true, -- close the terminal window when the process exits
                -- Change the default shell. Can be a string or a function returning a string
                shell = vim.o.shell,
                auto_scroll = true
            }
        }
}
