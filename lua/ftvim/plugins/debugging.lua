return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    config = function ()
        local dap = require('dap')
        local dapui = require('dapui')

        require("dapui").setup()
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
        dap.configurations.c = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }
        dap.adapters.codelldb = {
            type = 'server',
            host = '127.0.0.1',
            port = 13000,
            executable = {
                command = '/Users/tuta/codelldb/extension/adapter/codelldb',
                args = {"--port", "${port}"},
            }
        }
        vim.keymap.set('n', "<leader>dt", dap.toggle_breakpoint, {})
        vim.keymap.set('n', "<leader>dc", dap.continue, {})
        vim.keymap.set('n', '<leader>dn', function() require('dap').step_over() end)
        vim.keymap.set('n', '<leader>ds', function() require('dap').step_into() end)
        vim.keymap.set('n', '<leader>do', function() require('dap').step_out() end)
    end,
}
