return {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true,
        cmd = 'ToggleTerm',
        keys = {{ '<C-/', '<cmd>ToggleTerm<cr>', desc = 'Toggle floating term'}},
        opts = {
            direction = 'float',
            open_mapping = [[C-/>]],
            shade_filetypes = {},
            hide_numbers = true,
            insert_mappings = true,
            terminal_mappings = true,
            start_in_insert = true,
            close_on_exit = true,
        },
}
