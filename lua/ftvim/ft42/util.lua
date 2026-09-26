-- Shared helpers for the 42 tools

local M = {}

---Project root: the closest directory with a Makefile or .git, or the cwd
---@return string
function M.root()
  local buf = vim.api.nvim_buf_get_name(0)
  local start = buf ~= "" and vim.fs.dirname(buf) or vim.uv.cwd()
  local found = vim.fs.root(start, { "Makefile", ".git" })
  -- Don't escape the cwd: prefer it if the buffer lives inside it
  local cwd = vim.uv.cwd() --[[@as string]]
  if vim.uv.fs_stat(cwd .. "/Makefile") and (not found or vim.startswith(found, cwd)) then
    return cwd
  end
  return found or cwd
end

---Value of `NAME` in the project's Makefile
---@param root? string
---@return string?
function M.makefile_name(root)
  local path = (root or M.root()) .. "/Makefile"
  if not vim.uv.fs_stat(path) then
    return nil
  end
  for _, line in ipairs(vim.fn.readfile(path)) do
    local name = line:match "^%s*NAME%s*:?:?=%s*(%S+)"
    if name then
      return name
    end
  end
end

---Run a command asynchronously from inside a coroutine (see `M.async`)
---@param cmd string[]
---@param opts? vim.SystemOpts
---@return vim.SystemCompleted
function M.run(cmd, opts)
  local co = assert(coroutine.running(), "ftvim.ft42.util.run must be called inside M.async")
  opts = vim.tbl_extend("force", { text = true }, opts or {})
  local ok, err = pcall(vim.system, cmd, opts, function(result)
    vim.schedule(function()
      coroutine.resume(co, result)
    end)
  end)
  if not ok then
    -- Executable not found, etc.
    return { code = 127, signal = 0, stdout = "", stderr = tostring(err) }
  end
  return coroutine.yield()
end

---Run `fn` as a coroutine, reporting errors
---@param fn fun()
function M.async(fn)
  local co = coroutine.create(fn)
  local ok, err = coroutine.resume(co)
  if not ok then
    vim.notify(debug.traceback(co, err), vim.log.levels.ERROR, { title = "FtVim" })
  end
end

---Split output into lines, dropping the trailing empty line
---@param text? string
---@return string[]
function M.lines(text)
  local lines = vim.split(text or "", "\n", { plain = true })
  if lines[#lines] == "" then
    lines[#lines] = nil
  end
  return lines
end

local qf_types = { error = "E", ["fatal error"] = "E", warning = "W", note = "N" }

---Parse gcc/clang/ld/make output into quickfix items
---@param lines string[]
---@param cwd string Directory the command ran in (file names are relative to it)
---@return vim.quickfix.entry[]
function M.parse_errors(lines, cwd)
  local items = {}
  -- Track `make -C dir` so paths from sub-makes (e.g. libft) resolve correctly
  local dirs = { cwd }
  for _, line in ipairs(lines) do
    local file, lnum, col, kind, text = line:match "^([^:%s][^:]*):(%d+):(%d+): ([%a ]+): (.*)$"
    local entering = line:match "^make%[%d+%]: Entering directory ['`](.*)'$"
    if entering then
      table.insert(dirs, entering)
    elseif line:match "^make%[%d+%]: Leaving directory" then
      table.remove(dirs)
    elseif file and qf_types[kind] then
      local dir = dirs[#dirs] or cwd
      items[#items + 1] = {
        filename = vim.fs.normalize(vim.startswith(file, "/") and file or (dir .. "/" .. file)),
        lnum = tonumber(lnum),
        col = tonumber(col),
        type = qf_types[kind],
        text = text,
      }
    elseif line:match "undefined reference to" or line:match "^make.*%*%*%*" or line:match "Undefined symbols" then
      items[#items + 1] = { text = line, type = "E" }
    end
  end
  return items
end

---@param title string
---@param items vim.quickfix.entry[]
---@param open? boolean
function M.set_qf(title, items, open)
  vim.fn.setqflist({}, " ", { title = title, items = items })
  if open and #items > 0 then
    vim.cmd "botright copen"
  end
end

---Start LSP servers again for loaded buffers (vim.lsp.enable() starts them on FileType)
function M.reattach_lsp()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" and vim.bo[buf].filetype ~= "" then
      vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
    end
  end
end

---Restart the LSP clients with the given name
---@param name string
function M.restart_lsp(name)
  local clients = vim.lsp.get_clients { name = name }
  for _, client in ipairs(clients) do
    client:stop()
  end
  vim.defer_fn(M.reattach_lsp, #clients > 0 and 500 or 0)
end

---@param msg string
---@param level? integer
function M.notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "FtVim 42" })
end

return M
