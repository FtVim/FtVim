-- FtVim Debugging Extra (C/C++)
-- Enable with: { import = "ftvim.plugins.extras.dap" } (included in lang.42)
--
-- This extra includes:
-- - nvim-dap + nvim-dap-ui + inline variable values
-- - Adapter: gdb >= 14 (native DAP) when available, codelldb (Mason) otherwise
-- - Launch config that defaults to the Makefile's NAME
--
-- Compile with -g to get breakpoints and variables (e.g. add it to CFLAGS while debugging).

---@return string?
local function makefile_name()
  local path = vim.uv.cwd() .. "/Makefile"
  if vim.uv.fs_stat(path) then
    for _, line in ipairs(vim.fn.readfile(path)) do
      local name = line:match "^%s*NAME%s*:?:?=%s*(%S+)"
      if name then
        return name
      end
    end
  end
end

local function program()
  local default = makefile_name()
  local path = vim.fn.input("Program: ", default and ("./" .. default) or "", "file")
  return vim.fn.fnamemodify(path, ":p")
end

local function arguments()
  return vim.split(vim.fn.input "Arguments: ", " ", { trimempty = true })
end

---gdb supports DAP natively since version 14
---@return boolean
local function has_gdb_dap()
  if vim.fn.executable "gdb" == 0 then
    return false
  end
  local version = vim.system({ "gdb", "--version" }, { text = true }):wait().stdout or ""
  local major = tonumber(version:match "(%d+)%.%d+")
  return major ~= nil and major >= 14
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        -- stylua: ignore
        keys = {
          { "<leader>du", function() require("dapui").toggle {} end, desc = "Dap UI" },
          { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
        },
        opts = {},
        config = function(_, opts)
          local dap, dapui = require "dap", require "dapui"
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open {}
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close {}
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close {}
          end
        end,
      },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    -- stylua: ignore
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input "Condition: ") end, desc = "Conditional Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<F5>", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    },
    config = function()
      local dap = require "dap"
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "Visual" })

      local config
      if has_gdb_dap() then
        dap.adapters.gdb = {
          type = "executable",
          command = "gdb",
          args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
        }
        config = {
          name = "Launch (gdb)",
          type = "gdb",
          request = "launch",
          program = program,
          args = arguments,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        }
      else
        dap.adapters.codelldb = { type = "executable", command = "codelldb" }
        config = {
          name = "Launch (codelldb)",
          type = "codelldb",
          request = "launch",
          program = program,
          args = arguments,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        }
        if vim.fn.executable "codelldb" == 0 then
          vim.notify("No debugger found: install gdb >= 14 or run :MasonInstall codelldb", vim.log.levels.WARN)
        end
      end
      for _, ft in ipairs { "c", "cpp" } do
        dap.configurations[ft] = dap.configurations[ft] or {}
        table.insert(dap.configurations[ft], config)
      end
    end,
  },

  -- codelldb when gdb is missing (e.g. macOS)
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = vim.fn.executable "gdb" == 0 and { "codelldb" } or {},
    },
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>d", group = "Debug" },
      },
    },
  },
}
