-- File templates: 42 header on new files, header guards, C++ classes and compile_flags.txt

local util = require "ftvim.ft42.util"

local M = {}

---`libft.h` -> `LIBFT_H`, `Contact.hpp` -> `CONTACT_HPP`
---@param filename string
---@return string
function M.guard_name(filename)
  return (vim.fn.fnamemodify(filename, ":t"):upper():gsub("[^%w]", "_"))
end

---Lines of a header guard (42 norm: `# define` inside the #ifndef)
---@param filename string
---@return string[]
function M.header_guard(filename)
  local guard = M.guard_name(filename)
  return { "#ifndef " .. guard, "# define " .. guard, "", "", "", "#endif" }
end

---Insert the 42 header (and a guard for headers) into a new, empty buffer
---@param buf integer
function M.on_new_file(buf)
  if vim.g.ft42_auto_header == false then
    return
  end
  if vim.api.nvim_buf_line_count(buf) > 1 or vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] ~= "" then
    return
  end
  local name = vim.api.nvim_buf_get_name(buf)
  local ok = pcall(vim.cmd.Stdheader)
  if not ok then
    return
  end
  if name:match "%.h$" or name:match "%.hpp$" then
    -- Keep a single blank line between the header and the guard
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local last = #lines
    while last > 0 and lines[last] == "" do
      last = last - 1
    end
    vim.api.nvim_buf_set_lines(buf, last, -1, false, vim.list_extend({ "" }, M.header_guard(name)))
    vim.api.nvim_win_set_cursor(0, { last + 5, 0 })
  end
end

---Orthodox Canonical Form class (C++98), as required by the CPP modules
---@param class string
---@return string[] hpp, string[] cpp
function M.class_files(class)
  local guard = M.guard_name(class .. ".hpp")
  local hpp = {
    "#ifndef " .. guard,
    "# define " .. guard,
    "",
    "class " .. class,
    "{",
    "\tpublic:",
    ("\t\t%s(void);"):format(class),
    ("\t\t%s(const %s &other);"):format(class, class),
    ("\t\t%s &operator=(const %s &other);"):format(class, class),
    ("\t\t~%s(void);"):format(class),
    "",
    "\tprivate:",
    "};",
    "",
    "#endif",
  }
  local cpp = {
    ('#include "%s.hpp"'):format(class),
    "",
    ("%s::%s(void)"):format(class, class),
    "{",
    "}",
    "",
    ("%s::%s(const %s &other)"):format(class, class, class),
    "{",
    "\t*this = other;",
    "}",
    "",
    ("%s &%s::operator=(const %s &other)"):format(class, class, class),
    "{",
    "\tif (this != &other)",
    "\t{",
    "\t}",
    "\treturn (*this);",
    "}",
    "",
    ("%s::~%s(void)"):format(class, class),
    "{",
    "}",
  }
  return hpp, cpp
end

---:FtVimClass Name - create Name.hpp and Name.cpp (in include/ and src/ if they exist)
---@param class string
function M.create_class(class)
  if not class:match "^[%a_][%w_]*$" then
    return util.notify("Invalid class name: " .. class, vim.log.levels.ERROR)
  end
  local root = util.root()
  local function dir(candidates)
    for _, d in ipairs(candidates) do
      if vim.fn.isdirectory(root .. "/" .. d) == 1 then
        return root .. "/" .. d
      end
    end
    return root
  end
  local hpp_path = dir { "include", "includes", "inc" } .. "/" .. class .. ".hpp"
  local cpp_path = dir { "src", "srcs" } .. "/" .. class .. ".cpp"
  for _, path in ipairs { hpp_path, cpp_path } do
    if vim.uv.fs_stat(path) then
      return util.notify(vim.fn.fnamemodify(path, ":~:.") .. " already exists", vim.log.levels.ERROR)
    end
  end
  local hpp, cpp = M.class_files(class)
  vim.fn.writefile(hpp, hpp_path)
  vim.fn.writefile(cpp, cpp_path)
  vim.cmd.edit(vim.fn.fnameescape(cpp_path))
  vim.cmd.vsplit(vim.fn.fnameescape(hpp_path))
  util.notify(("Created %s.hpp and %s.cpp"):format(class, class))
end

---Flags for compile_flags.txt so clangd uses the 42 flags and finds the project headers
---@param root string
---@return string[]
function M.compile_flags(root)
  local files = vim.fs.find(function(name)
    return name:match "%.[ch]$" or name:match "%.[ch]pp$" or name:match "%.tpp$"
  end, { path = root, limit = math.huge, type = "file" })
  local cpp, include_dirs, seen = false, {}, {}
  for _, file in ipairs(files) do
    if file:match "%.cpp$" or file:match "%.hpp$" then
      cpp = true
    end
    if file:match "%.h$" or file:match "%.hpp$" or file:match "%.tpp$" then
      local d = vim.fs.dirname(file)
      if not seen[d] then
        seen[d] = true
        local rel = d == root and "." or d:sub(#root + 2)
        include_dirs[#include_dirs + 1] = "-I" .. rel
      end
    end
  end
  table.sort(include_dirs)
  local flags = { "-Wall", "-Wextra", "-Werror" }
  if cpp then
    vim.list_extend(flags, { "-xc++", "-std=c++98" })
  end
  return vim.list_extend(flags, include_dirs)
end

---:FtVimCompileFlags - write compile_flags.txt for clangd
function M.write_compile_flags()
  local root = util.root()
  local path = root .. "/compile_flags.txt"
  vim.fn.writefile(M.compile_flags(root), path)
  require("ftvim.ft42.compiledb").git_exclude(root, { "compile_flags.txt" })
  util.notify("Wrote " .. vim.fn.fnamemodify(path, ":~") .. " (git ignores it locally)")
  util.restart_lsp "clangd"
end

return M
