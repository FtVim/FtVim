-- Smoke test: checks that FtVim loads and that its config is actually applied.
-- Install plugins first with: nvim --headless -u tests/minimal_init.lua "+Lazy! sync" +qa
local failures = {}
local function check(cond, msg)
  if not cond then
    failures[#failures + 1] = msg
  end
end

-- Trigger lazy-loading of LSP and VeryLazy plugins
vim.cmd.edit(vim.fn.tempname() .. ".c")
vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
vim.wait(5000, function()
  return package.loaded["lspconfig"] ~= nil and package.loaded["which-key"] ~= nil
end)

check(vim.g.mapleader == " ", "options were not loaded (mapleader)")
check(vim.tbl_contains(vim.lsp.config.clangd.cmd or {}, "--background-index"), "clangd settings were not applied")
check(
  vim.tbl_get(vim.lsp.config.pyright, "settings", "python", "analysis", "typeCheckingMode") == "basic",
  "pyright settings were not applied"
)
check(vim.lsp.config.clangd.capabilities ~= nil, "LSP capabilities were not applied")
check(#vim.api.nvim_get_runtime_file("queries/c/textobjects.scm", false) > 0, "treesitter textobjects queries missing")
check(vim.fn.maparg("<leader>Fh", "n") ~= "", "42 extra mappings missing")

-- The server must stay up (e.g. clangd exits right away on invalid flags)
if vim.fn.exepath "clangd" ~= "" or vim.uv.fs_stat(vim.fn.stdpath "data" .. "/mason/bin/clangd") then
  vim.wait(5000, function()
    return #vim.lsp.get_clients { bufnr = 0, name = "clangd" } > 0
  end)
  vim.wait(2000)
  local client = vim.lsp.get_clients({ bufnr = 0, name = "clangd" })[1]
  check(client ~= nil and not client:is_stopped() and client.initialized, "clangd did not start or exited")
else
  io.stdout:write "SKIP clangd is not installed\n"
end

local errors = vim.tbl_filter(function(line)
  return line:match "E%d+:" or line:match "Error"
end, vim.split(vim.api.nvim_exec2("messages", { output = true }).output, "\n"))
check(#errors == 0, "errors during startup:\n  " .. table.concat(errors, "\n  "))

if #failures > 0 then
  io.stderr:write("FAILED:\n- " .. table.concat(failures, "\n- ") .. "\n")
  os.exit(1)
end
io.stdout:write "OK\n"
os.exit(0)
