-- compile_commands.json with compiledb (pip install compiledb), so clangd knows your flags and
-- include paths. compiledb parses a `make` dry-run: nothing is compiled.

local util = require "ftvim.ft42.util"

local M = {}

M.file = "compile_commands.json"

-- Projects already handled in this session by the automatic generation
local attempted = {} ---@type table<string, boolean>

---Keep generated files out of git without touching .gitignore (the repo is what you submit):
---adds them to .git/info/exclude, which is local and never committed.
---@param root string
---@param names string[]
function M.git_exclude(root, names)
  local result = vim.system({ "git", "rev-parse", "--git-path", "info/exclude" }, { cwd = root, text = true }):wait()
  if result.code ~= 0 then
    return
  end
  local path = vim.trim(result.stdout)
  if not vim.startswith(path, "/") then
    path = root .. "/" .. path
  end
  local lines = vim.uv.fs_stat(path) and vim.fn.readfile(path) or {}
  local missing = vim.tbl_filter(function(name)
    return not vim.tbl_contains(lines, name)
  end, names)
  if #missing > 0 then
    vim.fn.mkdir(vim.fs.dirname(path), "p")
    vim.fn.writefile(vim.list_extend(lines, missing), path)
  end
end

---Generate compile_commands.json in `root`. Must be called inside util.async.
---@param root string
---@return boolean ok, string? err
function M.run(root)
  if vim.fn.executable "compiledb" == 0 then
    return false, "compiledb is not installed (pipx install compiledb)"
  end
  local result = util.run({ "compiledb", "-n", "-f", "-o", M.file, "make" }, { cwd = root, env = { LC_ALL = "C" } })
  if result.code ~= 0 or not vim.uv.fs_stat(root .. "/" .. M.file) then
    return false, vim.trim(result.stderr ~= "" and result.stderr or result.stdout)
  end
  M.git_exclude(root, { M.file })
  return true
end

---@param root string
---@param opts? { silent?: boolean }
function M.generate(root, opts)
  opts = opts or {}
  util.async(function()
    local ok, err = M.run(root)
    if ok then
      if #vim.lsp.get_clients { name = "clangd" } > 0 then
        util.restart_lsp "clangd"
      end
      if not opts.silent then
        util.notify("Generated " .. vim.fn.fnamemodify(root .. "/" .. M.file, ":~") .. " (git ignores it locally)")
      end
    elseif not opts.silent then
      util.notify("Could not generate " .. M.file .. ": " .. (err or "unknown error"), vim.log.levels.ERROR)
    end
  end)
end

---:FtVimCompileDb
function M.command()
  local root = util.root()
  if not vim.uv.fs_stat(root .. "/Makefile") then
    return util.notify(
      "No Makefile in " .. vim.fn.fnamemodify(root, ":~") .. ". Try :FtVimCompileFlags",
      vim.log.levels.WARN
    )
  end
  M.generate(root)
end

---Generate it automatically the first time a C/C++ file of a Makefile project is opened
function M.auto()
  if vim.g.ft42_compile_db == false or vim.bo.buftype ~= "" or vim.fn.executable "compiledb" == 0 then
    return
  end
  local root = util.root()
  if attempted[root] or not vim.uv.fs_stat(root .. "/Makefile") or vim.uv.fs_stat(root .. "/" .. M.file) then
    return
  end
  attempted[root] = true
  M.generate(root, { silent = true })
end

---Keep it up to date when the Makefile changes
---@param makefile string
function M.on_makefile_write(makefile)
  local root = vim.fs.dirname(makefile)
  if vim.g.ft42_compile_db ~= false and vim.uv.fs_stat(root .. "/" .. M.file) then
    M.generate(root, { silent = true })
  end
end

return M
