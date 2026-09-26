-- :FtVimValgrind - run the project's binary under valgrind and send errors/leaks to the quickfix list

local util = require "ftvim.ft42.util"

local M = {}

M.args = {
  "--leak-check=full",
  "--show-leak-kinds=all",
  "--track-origins=yes",
}

---Parse a valgrind log into quickfix items (one per error/leak, pointing at the first project frame)
---@param lines string[]
---@param root string
---@return vim.quickfix.entry[] items, { errors: integer?, definitely_lost: string? } summary
function M.parse(lines, root)
  local items, summary = {}, {}
  local current ---@type {text: string, done: boolean, frames: integer}?

  local function in_project(file)
    local path = vim.startswith(file, "/") and file or (root .. "/" .. file)
    return vim.uv.fs_stat(path) and vim.startswith(vim.fs.normalize(path), root) and path or nil
  end

  for _, line in ipairs(lines) do
    local body = line:match "^==%d+== ?(.*)$"
    if body then
      local message = body:match "^(%S.*)$"
      local func, file, lnum = body:match "^%s+[ab][ty] 0x%x+: (.-) %(([^():]+):(%d+)%)$"
      local frame = body:match "^%s+[ab][ty] 0x%x+:"
      if message then
        summary.errors = tonumber(message:match "^ERROR SUMMARY: (%d+) errors") or summary.errors
        current = { text = message, done = false, frames = 0 }
      elseif body:match "^%s+definitely lost:" then
        summary.definitely_lost = body:match "definitely lost: ([%d,]+ bytes)"
      elseif frame and current and not current.done then
        current.frames = current.frames + 1
        local path = file and in_project(file)
        if path then
          current.done = true
          local kind = current.text:match "still reachable" and "W" or "E"
          items[#items + 1] =
            { filename = path, lnum = tonumber(lnum), type = kind, text = current.text .. " (" .. func .. ")" }
        end
      elseif not frame and current and not current.done and current.frames > 0 then
        -- Block with no frame in the project (e.g. only libc frames)
        current.done = true
        items[#items + 1] = { text = current.text, type = "E" }
      end
    end
  end
  return items, summary
end

---@param args string[] Arguments for the program
function M.run(args)
  if vim.fn.executable "valgrind" == 0 then
    local hint = vim.uv.os_uname().sysname == "Darwin" and " (not available on macOS, try `leaks --atExit -- ./prog`)"
      or ""
    return util.notify("valgrind is not installed" .. hint, vim.log.levels.ERROR)
  end
  local root = util.root()
  local name = util.makefile_name(root)
  local program = vim.g.ft42_valgrind_program or (name and "./" .. name)
  if not program then
    return util.notify("Could not find NAME in the Makefile. Set vim.g.ft42_valgrind_program", vim.log.levels.ERROR)
  end
  if not vim.uv.fs_stat(vim.fs.joinpath(root, program)) and not vim.uv.fs_stat(program) then
    return util.notify(program .. " not found. Build it first (:FtVimMake)", vim.log.levels.ERROR)
  end

  local log = vim.fn.tempname()
  local cmd = vim.list_extend({ "valgrind", "--log-file=" .. log }, M.args)
  vim.list_extend(cmd, { program })
  vim.list_extend(cmd, args)

  -- Run in a terminal so interactive programs (minishell, ...) work
  vim.cmd "botright 15new"
  vim.fn.jobstart(cmd, {
    term = true,
    cwd = root,
    on_exit = function()
      vim.schedule(function()
        local lines = vim.uv.fs_stat(log) and vim.fn.readfile(log) or {}
        vim.fn.delete(log)
        local items, summary = M.parse(lines, root)
        util.set_qf("Valgrind", items, true)
        local ok = (summary.errors or 0) == 0 and #items == 0
        util.notify(
          ("Valgrind: %s errors%s"):format(
            summary.errors or "?",
            summary.definitely_lost and (", definitely lost: " .. summary.definitely_lost) or ""
          ),
          ok and vim.log.levels.INFO or vim.log.levels.WARN
        )
      end)
    end,
  })
  vim.cmd.startinsert()
end

return M
