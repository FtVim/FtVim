-- Norminette linter for nvim-lint
-- Lints the buffer contents (not the file on disk) so errors update without saving.

local M = {}

-- Norminette reports visual columns with a tab width of 4
local TABSTOP = 4
-- Above this size the buffer is too big to pass as an argument, so lint the saved file instead
local MAX_ARG_SIZE = 100 * 1024

---Convert a 1-based visual column (tabs = 4) to a 0-based byte column
---@param line string
---@param vcol integer
---@return integer
function M.visual_to_byte_col(line, vcol)
  local v = 1
  for i = 1, #line do
    if v >= vcol then
      return i - 1
    end
    if line:sub(i, i) == "\t" then
      v = v + (TABSTOP - (v - 1) % TABSTOP)
    else
      v = v + 1
    end
  end
  return #line
end

local severities = {
  Error = vim.diagnostic.severity.ERROR,
  Notice = vim.diagnostic.severity.WARN,
}

---Parse `norminette -f json` output into diagnostics
---@param output string
---@param bufnr integer
---@return vim.Diagnostic[]
function M.parse(output, bufnr)
  local ok, decoded = pcall(vim.json.decode, output)
  if not ok or type(decoded) ~= "table" or type(decoded.files) ~= "table" then
    return {}
  end
  vim.b[bufnr].ftvim_norminette_linted = true
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local diagnostics = {}
  for _, file in ipairs(decoded.files) do
    for _, err in ipairs(file.errors or {}) do
      local pos = (err.highlights or {})[1] or {}
      local lnum = math.max((pos.lineno or 1) - 1, 0)
      diagnostics[#diagnostics + 1] = {
        lnum = lnum,
        col = M.visual_to_byte_col(lines[lnum + 1] or "", pos.column or 1),
        severity = severities[err.level] or vim.diagnostic.severity.ERROR,
        source = "norminette",
        code = err.name,
        message = err.text,
      }
    end
  end
  return diagnostics
end

---nvim-lint linter definition (evaluated for every lint run)
---@return table
function M.linter()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n") .. "\n"
  local args = { "-f", "json" }
  if #content <= MAX_ARG_SIZE then
    local flag = filename:match "%.h$" and "--hfile" or "--cfile"
    vim.list_extend(args, { flag, content, "--filename", filename })
  else
    args[#args + 1] = filename
  end
  return {
    name = "norminette",
    cmd = "norminette",
    args = args,
    stdin = false,
    append_fname = false,
    stream = "stdout",
    ignore_exitcode = true,
    parser = M.parse,
  }
end

---Number of norminette errors in a buffer, or nil if it hasn't been linted yet
---@param bufnr? integer
---@return integer?
function M.count(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if not package.loaded.lint or not vim.b[bufnr].ftvim_norminette_linted then
    return nil
  end
  local ns = require("lint").get_namespace "norminette"
  return #vim.diagnostic.get(bufnr, { namespace = ns })
end

return M
