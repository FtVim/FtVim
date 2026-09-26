-- :checkhealth ftvim

local M = {}

local health = vim.health

---@param cmd string
---@param opts { hint: string, optional?: boolean, version_args?: string[] }
local function executable(cmd, opts)
  if vim.fn.executable(cmd) == 1 then
    local version = ""
    if opts.version_args then
      local ok, result = pcall(function()
        return vim.system(vim.list_extend({ cmd }, opts.version_args), { text = true }):wait(2000)
      end)
      if ok and result.stdout then
        version = " (" .. vim.trim(vim.split(result.stdout, "\n")[1]) .. ")"
      end
    end
    health.ok(("`%s` found%s"):format(cmd, version))
    return true
  end
  local report = opts.optional and health.warn or health.error
  report(("`%s` not found"):format(cmd), opts.hint)
  return false
end

---@param module string
---@return boolean
local function extra_enabled(module)
  local ok, Config = pcall(require, "lazy.core.config")
  return ok and vim.tbl_contains(Config.spec and Config.spec.modules or {}, module)
end

function M.check()
  health.start "FtVim"
  health.info("FtVim version " .. require("ftvim").version)
  if vim.fn.has "nvim-0.11" == 1 then
    health.ok("Neovim " .. tostring(vim.version()))
  else
    health.error("Neovim >= 0.11 is required", "Update with scripts/install-neovim.sh")
  end
  executable("git", { hint = "Needed to install plugins", version_args = { "--version" } })
  executable("rg", { hint = "Needed for grep (<leader>fs). Install with scripts/install-ripgrep.sh" })
  executable("cc", { hint = "Needed to compile treesitter parsers" })
  executable("fd", { hint = "Optional, makes the file picker faster", optional = true })
  health.info "Icons need a Nerd Font in your terminal: if you see squares instead of icons, install one"

  if extra_enabled "ftvim.plugins.extras.lang.42" then
    health.start "FtVim: 42"
    local pip = "Install with: pipx install norminette c-formatter-42 (or pip install --user ...)"
    executable("norminette", { hint = pip, version_args = { "--version" } })
    executable("c_formatter_42", { hint = pip })
    executable("make", { hint = "Needed for :FtVimMake and :FtVimCheck" })
    executable("compiledb", {
      hint = "Needed to generate compile_commands.json for clangd: pipx install compiledb",
      optional = true,
    })
    executable("nm", { hint = "Needed by :FtVimCheck to list the functions you use", optional = true })
    if vim.uv.os_uname().sysname == "Darwin" then
      health.info "valgrind is not available on macOS: use `leaks --atExit -- ./program`"
    else
      executable("valgrind", { hint = "Needed for :FtVimValgrind", optional = true })
    end
    if vim.g.user42 and vim.g.user42 ~= "marvin" then
      health.ok(("42 header: %s <%s>"):format(vim.g.user42, vim.g.mail42))
    else
      health.warn(
        "42 header user is not set",
        "Set vim.g.user42 and vim.g.mail42 in lua/config/options.lua, or export USER42 and MAIL42"
      )
    end
  end

  if extra_enabled "ftvim.plugins.extras.dap" then
    health.start "FtVim: debugging"
    if vim.fn.executable "gdb" == 1 then
      executable("gdb", { hint = "", version_args = { "--version" } })
      health.info "gdb >= 14 is needed for its native DAP support"
    else
      executable("codelldb", { hint = "Install with :MasonInstall codelldb" })
    end
  end

  if extra_enabled "ftvim.plugins.extras.copilot" then
    health.start "FtVim: Copilot"
    executable("node", { hint = "Copilot needs Node.js", version_args = { "--version" } })
  end
end

return M
