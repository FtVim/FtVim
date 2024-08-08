local M = {}

M.config = function()
    ftvim.builtin.copilot = {
        active = false,
        on_config_done = nil,
        options = {
            panel = {
                keymap = {
                    jump_next = "<c-j>",
                    jump_prev = "<c-k>",
                    accept = "<c-l>",
                    refresh = "r",
                    open = "<M-CR>",
                },
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                keymap = {
                    accept = "<c-l>",
                    next = "<c-j>",
                    prev = "<c-k>",
                    dismiss = "<c-h>",
                },
            },
            filetypes = {
                yaml = false,
                markdown = true,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
        },
    }
end

M.setup = function()
    local status_ok, copilot = pcall(require, "copilot")
    if not status_ok then
        print("Error loading copilot")
        return
    end

    local config_ok, _ = pcall(copilot.setup, ftvim.builtin.copilot.options)
    if not config_ok then
        return
    end

    if ftvim.builtin.copilot.on_config_done then
        ftvim.builtin.copilot.on_config_done()
    end

    local opts = { noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", "<c-s>", "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)
end

return M
