-- :FtVimCheck (pre-submission checks), :FtVimNorm and :FtVimMake

local norminette = require "ftvim.ft42.norminette"
local util = require "ftvim.ft42.util"

local M = {}

local ENV = { LC_ALL = "C" }

---Parse `norminette -f json` output for a whole project into quickfix items
---@param output string
---@return vim.quickfix.entry[]
function M.norm_items(output)
  local ok, decoded = pcall(vim.json.decode, output)
  if not ok or type(decoded) ~= "table" then
    return {}
  end
  local items = {}
  for _, file in ipairs(decoded.files or {}) do
    local lines = vim.uv.fs_stat(file.path) and vim.fn.readfile(file.path) or {}
    for _, err in ipairs(file.errors or {}) do
      local pos = (err.highlights or {})[1] or {}
      local lnum = pos.lineno or 1
      items[#items + 1] = {
        filename = file.path,
        lnum = lnum,
        col = norminette.visual_to_byte_col(lines[lnum] or "", pos.column or 1) + 1,
        type = err.level == "Notice" and "W" or "E",
        text = ("%s: %s"):format(err.name, err.text),
      }
    end
  end
  return items
end

---Runs norminette on the project. Must be called inside util.async.
---@param root string
---@return vim.quickfix.entry[]? items nil if norminette is not installed
function M.run_norm(root)
  if vim.fn.executable "norminette" == 0 then
    return nil
  end
  local result = util.run({ "norminette", "-f", "json" }, { cwd = root, env = ENV })
  return M.norm_items(result.stdout)
end

---Checks the Makefile for the mandatory rules and flags
---@param root string
---@return string[] problems
function M.makefile_problems(root)
  local path = root .. "/Makefile"
  if not vim.uv.fs_stat(path) then
    return { "No Makefile found" }
  end
  local content = table.concat(vim.fn.readfile(path), "\n")
  local problems = {}
  for _, rule in ipairs { "all", "clean", "fclean", "re" } do
    if not content:match("\n" .. rule .. "%s*:") and not content:match("^" .. rule .. "%s*:") then
      problems[#problems + 1] = ("Missing rule '%s'"):format(rule)
    end
  end
  if not content:match "%$%(NAME%)%s*:" and not content:match "%${NAME}%s*:" then
    problems[#problems + 1] = "Missing rule '$(NAME)'"
  end
  for _, flag in ipairs { "-Wall", "-Wextra", "-Werror" } do
    if not content:find(flag, 1, true) then
      problems[#problems + 1] = ("Missing flag %s"):format(flag)
    end
  end
  return problems
end

---Lines from `make -n` that mean something would be rebuilt (i.e. a relink)
---@param output string
---@return string[]
function M.relink_lines(output)
  return vim.tbl_filter(function(line)
    return line ~= ""
      and not line:match "Nothing to be done"
      and not line:match "is up to date"
      and not line:match "^make%[%d+%]: [EL]%a+ing directory"
      and not line:match "^make: [EL]%a+ing directory"
  end, util.lines(output))
end

local ignored_symbol = function(name)
  return name:match "^__" or name:match "^_ITM_" or name:match "^_GLOBAL_" or name == "dyld_stub_binder"
end

---External functions used by a binary/library: undefined symbols not defined inside it
---@param output string `nm -g` output
---@return string[]
function M.external_functions(output)
  local defined, undefined = {}, {}
  local darwin = vim.uv.os_uname().sysname == "Darwin"
  for _, line in ipairs(util.lines(output)) do
    local kind, name = line:match "^%s*%x*%s+(%a)%s+(.+)$"
    if name then
      name = name:gsub("@.*$", "")
      if darwin then
        name = name:gsub("^_", "")
      end
      if kind == "U" then
        undefined[name] = true
      else
        defined[name] = true
      end
    end
  end
  local used = {}
  for name in pairs(undefined) do
    if not defined[name] and not ignored_symbol(name) then
      used[#used + 1] = name
    end
  end
  table.sort(used)
  return used
end

---Allowed functions: command arguments, `vim.g.ft42_allowed_functions`, or `.allowed_functions` in the root
---@param root string
---@param args string[]
---@return string[]?
function M.allowed_functions(root, args)
  if #args > 0 then
    return args
  end
  if type(vim.g.ft42_allowed_functions) == "table" then
    return vim.g.ft42_allowed_functions
  end
  local file = root .. "/.allowed_functions"
  if vim.uv.fs_stat(file) then
    return vim.tbl_filter(function(name)
      return name ~= ""
    end, vim.split(table.concat(vim.fn.readfile(file), " "), "[%s,]+"))
  end
end

---:FtVimCheck [allowed functions...]
---@param args string[]
function M.check(args)
  local root = util.root()
  util.async(function()
    util.notify("Checking " .. vim.fn.fnamemodify(root, ":~") .. " ...")
    local items, summary = {}, {}
    local function section(title, entries)
      if #entries > 0 then
        items[#items + 1] = { text = "── " .. title .. " ──" }
        vim.list_extend(items, entries)
      end
    end

    -- 1. Norminette
    local norm = M.run_norm(root)
    if not norm then
      summary[#summary + 1] = "⚠ Norminette: not installed (pip install --user norminette)"
    else
      local errors = #vim.tbl_filter(function(i)
        return i.type == "E"
      end, norm)
      summary[#summary + 1] = errors == 0 and "✓ Norminette: OK" or ("✗ Norminette: %d errors"):format(errors)
      section("Norminette", norm)
    end

    -- 2. Makefile rules and flags
    local problems = M.makefile_problems(root)
    summary[#summary + 1] = #problems == 0 and "✓ Makefile: rules and flags OK"
      or ("✗ Makefile: %d problems"):format(#problems)
    section(
      "Makefile",
      vim.tbl_map(function(p)
        return { filename = root .. "/Makefile", lnum = 1, text = p, type = "E" }
      end, problems)
    )

    if vim.uv.fs_stat(root .. "/Makefile") then
      -- 3. Build from scratch
      local build = util.run({ "make", "re" }, { cwd = root, env = ENV })
      local build_lines = util.lines(build.stdout .. "\n" .. build.stderr)
      section("make re", util.parse_errors(build_lines, root))
      if build.code ~= 0 then
        summary[#summary + 1] = "✗ make re: failed"
      else
        summary[#summary + 1] = "✓ make re: OK"

        -- 4. Relink: after a full build, `make` must have nothing to do
        local dry = util.run({ "make", "-n" }, { cwd = root, env = ENV })
        local relink = M.relink_lines(dry.stdout)
        summary[#summary + 1] = #relink == 0 and "✓ Relink: none" or "✗ Relink: `make` rebuilds after `make re`"
        section(
          "Relink (commands `make` would run again)",
          vim.tbl_map(function(l)
            return { text = l, type = "E" }
          end, relink)
        )

        -- 5. External functions
        local name = util.makefile_name(root)
        local binary = name and root .. "/" .. name
        if binary and vim.uv.fs_stat(binary) and vim.fn.executable "nm" == 1 then
          local nm = util.run({ "nm", "-g", binary }, { cwd = root, env = ENV })
          local used = M.external_functions(nm.stdout)
          local allowed = M.allowed_functions(root, args)
          if allowed then
            local forbidden = vim.tbl_filter(function(f)
              return not vim.tbl_contains(allowed, f)
            end, used)
            summary[#summary + 1] = #forbidden == 0 and "✓ Functions: only allowed ones"
              or ("✗ Functions: %d forbidden (%s)"):format(#forbidden, table.concat(forbidden, ", "))
            section(
              "Forbidden functions",
              vim.tbl_map(function(f)
                return { text = f, type = "E" }
              end, forbidden)
            )
          else
            summary[#summary + 1] = ("ℹ Functions used: %s"):format(#used > 0 and table.concat(used, ", ") or "none")
          end
        end
      end
    end

    util.set_qf("FtVimCheck", items, true)
    local failed = vim.iter(summary):any(function(s)
      return s:match "^✗"
    end)
    util.notify(table.concat(summary, "\n"), failed and vim.log.levels.WARN or vim.log.levels.INFO)
  end)
end

---:FtVimNorm - norminette on the whole project into the quickfix list
function M.norm()
  local root = util.root()
  util.async(function()
    local items = M.run_norm(root)
    if not items then
      return util.notify("norminette is not installed (pip install --user norminette)", vim.log.levels.ERROR)
    end
    util.set_qf("Norminette", items, true)
    util.notify(#items == 0 and "Norminette: OK" or ("Norminette: %d errors"):format(#items))
  end)
end

---:FtVimMake [target] - async make into the quickfix list
---@param args string[]
function M.make(args)
  local root = util.root()
  util.async(function()
    local cmd = vim.list_extend({ "make" }, args)
    util.notify("Running " .. table.concat(cmd, " ") .. " ...")
    local result = util.run(cmd, { cwd = root, env = ENV })
    local items = util.parse_errors(util.lines(result.stdout .. "\n" .. result.stderr), root)
    util.set_qf(table.concat(cmd, " "), items, true)
    if result.code == 0 then
      util.notify(table.concat(cmd, " ") .. ": OK" .. (#items > 0 and (" (%d warnings)"):format(#items) or ""))
    else
      util.notify(table.concat(cmd, " ") .. ": failed", vim.log.levels.ERROR)
    end
  end)
end

return M
