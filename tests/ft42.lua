-- Tests for the 42 tools. Run after installing plugins (see tests/minimal_init.lua):
--   nvim --headless -u tests/minimal_init.lua "+luafile tests/ft42.lua"
-- Tests that need norminette / c_formatter_42 are skipped when they are not installed.

local failures, passed, skipped = {}, 0, {}
local function test(name, fn)
  local ok, err = pcall(fn)
  if ok then
    passed = passed + 1
  else
    failures[#failures + 1] = name .. ": " .. tostring(err)
  end
end
local function eq(actual, expected, what)
  if not vim.deep_equal(actual, expected) then
    error(("%s: expected %s, got %s"):format(what or "value", vim.inspect(expected), vim.inspect(actual)), 2)
  end
end
local function skip_unless(cmd, name)
  if vim.fn.executable(cmd) == 0 then
    skipped[#skipped + 1] = name .. " (" .. cmd .. " not installed)"
    return true
  end
end

vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp, "p")
vim.g.user42, vim.g.mail42 = "marvin42", "marvin42@student.42barcelona.com"

local norminette = require "ftvim.ft42.norminette"
local check = require "ftvim.ft42.check"
local valgrind = require "ftvim.ft42.valgrind"
local templates = require "ftvim.ft42.templates"
local util = require "ftvim.ft42.util"

-- Unit tests ----------------------------------------------------------------

test("visual columns (tab = 4) to byte columns", function()
  eq(norminette.visual_to_byte_col("\tint\ta;", 9), 5, "after tabs")
  eq(norminette.visual_to_byte_col("int x;", 5), 4, "no tabs")
  eq(norminette.visual_to_byte_col("", 3), 0, "empty line")
end)

test("norminette JSON parser", function()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "int main(void){", "\tint\ta;" })
  local output = vim.json.encode {
    files = {
      {
        path = "x.c",
        status = "Error",
        errors = {
          { name = "SPACE_BEFORE_FUNC", text = "space", level = "Error", highlights = { { lineno = 1, column = 4 } } },
          { name = "GLOBAL_VAR", text = "global", level = "Notice", highlights = { { lineno = 2, column = 9 } } },
        },
      },
    },
  }
  local diags = norminette.parse(output, buf)
  eq(#diags, 2, "count")
  eq({ diags[1].lnum, diags[1].col, diags[1].code }, { 0, 3, "SPACE_BEFORE_FUNC" }, "first")
  eq({ diags[2].lnum, diags[2].col, diags[2].severity }, { 1, 5, vim.diagnostic.severity.WARN }, "notice")
  eq(norminette.parse("not json", buf), {}, "invalid output")
end)

test("relink detection", function()
  eq(check.relink_lines "make: Nothing to be done for 'all'.\n", {}, "nothing to do")
  eq(check.relink_lines "make: 'push_swap' is up to date.\n", {}, "up to date")
  eq(check.relink_lines "cc -o prog main.o\n", { "cc -o prog main.o" }, "relink")
end)

test("external functions from nm", function()
  local nm = table.concat({
    "                 U __libc_start_main@GLIBC_2.34",
    "                 U malloc@GLIBC_2.2.5",
    "                 U write@GLIBC_2.2.5",
    "0000000000001139 T ft_strlen",
    "                 U ft_strlen",
    "                 w __gmon_start__",
  }, "\n")
  eq(check.external_functions(nm), { "malloc", "write" }, "functions")
end)

test("Makefile checks", function()
  local root = tmp .. "/mk"
  vim.fn.mkdir(root, "p")
  vim.fn.writefile(
    { "NAME = prog", "CFLAGS = -Wall -Wextra", "all: $(NAME)", "$(NAME):", "clean:", "re: fclean all" },
    root .. "/Makefile"
  )
  eq(check.makefile_problems(root), { "Missing rule 'fclean'", "Missing flag -Werror" }, "problems")
  eq(util.makefile_name(root), "prog", "NAME")
end)

test("compiler output parser", function()
  local items = util.parse_errors({
    "main.c:3:5: error: unknown type name 'foo'",
    "make[1]: Entering directory '/abs/libft'",
    "ft_strlen.c:2:1: warning: unused",
    "make[1]: Leaving directory '/abs/libft'",
    "cc -Wall -c main.c",
    "/usr/bin/ld: main.o: undefined reference to `ft_putstr'",
  }, "/proj")
  eq(#items, 3, "count")
  eq({ items[1].filename, items[1].lnum, items[1].type }, { "/proj/main.c", 3, "E" }, "error")
  eq({ items[2].filename, items[2].type }, { "/abs/libft/ft_strlen.c", "W" }, "sub-make")
  eq(items[3].filename, nil, "linker error has no file")
end)

test("valgrind parser", function()
  local root = tmp .. "/vg"
  vim.fn.mkdir(root, "p")
  vim.fn.writefile({ "" }, root .. "/main.c")
  local log = {
    "==42== Memcheck, a memory error detector",
    "==42== Invalid read of size 4",
    "==42==    at 0x109161: main (main.c:6)",
    "==42==  Address 0x4a8e044 is 0 bytes after a block of size 4 alloc'd",
    "==42==    at 0x48437B4: malloc (vg_replace_malloc.c:381)",
    "==42==    by 0x109155: main (main.c:5)",
    "==42== ",
    "==42== 40 bytes in 1 blocks are definitely lost in loss record 1 of 1",
    "==42==    at 0x48437B4: malloc (vg_replace_malloc.c:381)",
    "==42==    by 0x10914A: main (main.c:4)",
    "==42== LEAK SUMMARY:",
    "==42==    definitely lost: 40 bytes in 1 blocks",
    "==42== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 0 from 0)",
  }
  local items, summary = valgrind.parse(log, root)
  eq(#items, 2, "count")
  eq({ items[1].lnum, items[1].text }, { 6, "Invalid read of size 4 (main)" }, "invalid read")
  eq(items[2].lnum, 4, "leak points at the malloc caller")
  eq(summary, { errors = 2, definitely_lost = "40 bytes" }, "summary")
end)

test("templates", function()
  eq(templates.guard_name "ft_printf.h", "FT_PRINTF_H", "guard")
  eq(templates.header_guard("libft.h")[2], "# define LIBFT_H", "guard lines")
  local hpp, cpp = templates.class_files "Fixed"
  assert(vim.tbl_contains(hpp, "\t\tFixed &operator=(const Fixed &other);"), "hpp has assignment operator")
  assert(vim.tbl_contains(cpp, "Fixed::~Fixed(void)"), "cpp has destructor")
  local root = tmp .. "/flags"
  vim.fn.mkdir(root .. "/include", "p")
  vim.fn.mkdir(root .. "/src", "p")
  vim.fn.writefile({ "" }, root .. "/include/a.hpp")
  vim.fn.writefile({ "" }, root .. "/src/a.cpp")
  eq(templates.compile_flags(root), { "-Wall", "-Wextra", "-Werror", "-xc++", "-std=c++98", "-Iinclude" }, "flags")
end)

-- Integration tests ---------------------------------------------------------

test(".h files are C", function()
  eq(vim.filetype.match { filename = "libft.h" }, "c", "filetype")
end)

test("new files get the 42 header and a guard", function()
  vim.cmd.edit(tmp .. "/ft_test.h")
  vim.wait(2000, function()
    return vim.api.nvim_buf_line_count(0) > 5
  end)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  assert(lines[1]:match "^/%* %*+ %*/$", "header first line: " .. tostring(lines[1]))
  assert(table.concat(lines, "\n"):find("marvin42", 1, true), "header has the user")
  local guard = vim.fn.index(lines, "#ifndef FT_TEST_H") + 1
  assert(guard > 0, "guard")
  eq({ lines[guard - 2]:sub(1, 3), lines[guard - 1] }, { "/* ", "" }, "one blank line between header and guard")
  vim.cmd "bwipeout!"
end)

test("exam mode", function()
  local exam = require "ftvim.ft42.exam"
  exam.enable()
  eq(vim.g.ftvim_completion, false, "completion off")
  eq(vim.diagnostic.is_enabled(), false, "diagnostics off")
  exam.disable()
  eq(vim.g.ftvim_completion, nil, "completion restored")
  eq(vim.diagnostic.is_enabled(), true, "diagnostics restored")
end)

test("extras list and toggle", function()
  local extras = require "ftvim.extras"
  local names = vim.tbl_map(function(e)
    return e.name
  end, extras.list())
  for _, name in ipairs { "lang.42", "lang.cpp", "lang.docker", "lang.web", "lang.python", "dap", "copilot" } do
    assert(vim.tbl_contains(names, name), "missing extra " .. name)
  end
  local module = "ftvim.plugins.extras.copilot"
  extras.toggle(module)
  assert(vim.tbl_contains(extras.read().extras, module), "enabled in ftvim.json")
  extras.toggle(module)
  assert(not vim.tbl_contains(extras.read().extras, module), "disabled in ftvim.json")
end)

test("checkhealth ftvim", function()
  vim.cmd "checkhealth ftvim"
  local text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  assert(text:find "FtVim: 42", "42 section")
  assert(not text:find "Failed to run healthcheck", "healthcheck crashed:\n" .. text)
  vim.cmd "bwipeout!"
end)

if not skip_unless("norminette", "norminette diagnostics while typing") then
  test("norminette diagnostics while typing", function()
    vim.cmd.edit(tmp .. "/live.c")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "int main(void){", "\treturn (0);", "}" })
    local ns = require("lint").get_namespace "norminette"
    local function codes()
      return vim.tbl_map(function(d)
        return d.code
      end, vim.diagnostic.get(0, { namespace = ns }))
    end
    require("lint").try_lint()
    assert(
      vim.wait(10000, function()
        return vim.tbl_contains(codes(), "BRACE_NEWLINE")
      end),
      "expected BRACE_NEWLINE, got " .. vim.inspect(codes())
    )
    -- Fix the brace without saving: diagnostics follow the buffer, not the file
    vim.api.nvim_buf_set_lines(0, 0, 1, false, { "int\tmain(void)", "{" })
    require("lint").try_lint()
    assert(
      vim.wait(10000, function()
        return not vim.tbl_contains(codes(), "BRACE_NEWLINE") and #codes() > 0
      end),
      "BRACE_NEWLINE should be gone, got " .. vim.inspect(codes())
    )
    eq(norminette.count(), #codes(), "statusline count")
    vim.cmd "bwipeout!"
  end)
end

if not skip_unless("c_formatter_42", "c_formatter_42 via conform") then
  test("c_formatter_42 via conform", function()
    vim.cmd.edit(tmp .. "/fmt.c")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "int main(void){", "  return 0;", "}" })
    require("conform").format { bufnr = 0, async = false, timeout_ms = 10000 }
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    eq(lines, { "int\tmain(void)", "{", "\treturn (0);", "}" }, "formatted")
    vim.cmd "bwipeout!"
  end)
end

if not skip_unless("make", ":FtVimCheck") and not skip_unless("nm", ":FtVimCheck") then
  test(":FtVimCheck finds forbidden functions and relink", function()
    local root = tmp .. "/proj"
    vim.fn.mkdir(root, "p")
    vim.fn.writefile(
      { "#include <stdio.h>", "int\tmain(void)", "{", '\tprintf("hi");', "\treturn (0);", "}" },
      root .. "/main.c"
    )
    -- `all` always relinks
    vim.fn.writefile({
      "NAME = prog",
      "CFLAGS = -Wall -Wextra -Werror",
      "all: $(NAME)",
      "$(NAME):",
      "\tcc $(CFLAGS) main.c -o $(NAME)",
      "clean:",
      "fclean: clean",
      "\trm -f $(NAME)",
      "re: fclean all",
      ".PHONY: all clean fclean re $(NAME)",
    }, root .. "/Makefile")
    vim.cmd.cd(root)
    vim.fn.setqflist({}, "f")
    check.check { "write" }
    assert(
      vim.wait(30000, function()
        return vim.fn.getqflist({ title = 1 }).title == "FtVimCheck"
      end),
      "check did not finish"
    )
    local texts = vim.tbl_map(function(i)
      return i.text
    end, vim.fn.getqflist())
    assert(vim.tbl_contains(texts, "printf"), "printf should be forbidden: " .. vim.inspect(texts))
    assert(vim.tbl_contains(texts, "cc -Wall -Wextra -Werror main.c -o prog"), "relink: " .. vim.inspect(texts))
  end)
end

---Sample project: include/ headers, objects in obj/, libft built by a sub-make
local function make_project(root)
  vim.fn.mkdir(root .. "/src", "p")
  vim.fn.mkdir(root .. "/include", "p")
  vim.fn.mkdir(root .. "/libft", "p")
  vim.fn.writefile({
    '#include "push_swap.h"',
    '#include "libft.h"',
    "",
    "int\tmain(void)",
    "{",
    "\tint\tunused;",
    "",
    '\treturn (ft_strlen("a"));',
    "}",
  }, root .. "/src/main.c")
  vim.fn.writefile({ "#ifndef PUSH_SWAP_H", "# define PUSH_SWAP_H", "#endif" }, root .. "/include/push_swap.h")
  vim.fn.writefile({ "int\tft_strlen(char *s);" }, root .. "/libft/libft.h")
  vim.fn.writefile(
    { '#include "libft.h"', "int\tft_strlen(char *s)", "{", "\treturn (s[0] != 0);", "}" },
    root .. "/libft/ft_strlen.c"
  )
  vim.fn.writefile({
    "NAME = libft.a",
    "all: $(NAME)",
    "$(NAME): ft_strlen.o",
    "\tar rcs $(NAME) ft_strlen.o",
    "%.o: %.c",
    "\tcc -Wall -Wextra -Werror -c $< -o $@",
  }, root .. "/libft/Makefile")
  vim.fn.writefile({
    "NAME = push_swap",
    "CFLAGS = -Wall -Wextra -Werror -Iinclude -Ilibft",
    "all: $(NAME)",
    "$(NAME): obj/main.o",
    "\t$(MAKE) -C libft",
    "\tcc $(CFLAGS) obj/main.o -Llibft -lft -o $(NAME)",
    "obj/%.o: src/%.c",
    "\t@mkdir -p obj",
    "\tcc $(CFLAGS) -c $< -o $@",
  }, root .. "/Makefile")
  vim.system({ "git", "init", "-q" }, { cwd = root }):wait()
end

if not skip_unless("compiledb", "compile_commands.json") then
  test("compile_commands.json with compiledb", function()
    local compiledb = require "ftvim.ft42.compiledb"
    local root = tmp .. "/cdb"
    make_project(root)
    local done, ok, err = false, nil, nil
    util.async(function()
      ok, err = compiledb.run(root)
      done = true
    end)
    assert(
      vim.wait(30000, function()
        return done
      end),
      "compiledb timed out"
    )
    assert(ok, "compiledb failed: " .. tostring(err))
    local db = vim.json.decode(table.concat(vim.fn.readfile(root .. "/compile_commands.json"), "\n"))
    local files = vim.tbl_map(function(entry)
      return vim.fs.normalize(entry.directory .. "/" .. entry.file)
    end, db)
    table.sort(files)
    eq(files, { root .. "/libft/ft_strlen.c", root .. "/src/main.c" }, "entries (including the libft sub-make)")
    eq(vim.fn.glob(root .. "/**/*.o"), "", "nothing was compiled")
    assert(vim.tbl_contains(vim.fn.readfile(root .. "/.git/info/exclude"), "compile_commands.json"), "git exclude")
  end)

  test("compile_commands.json is generated when opening a project", function()
    local root = tmp .. "/cdb_auto"
    make_project(root)
    vim.cmd.cd(root)
    vim.cmd.edit(root .. "/src/main.c")
    assert(
      vim.wait(30000, function()
        return vim.uv.fs_stat(root .. "/compile_commands.json") ~= nil
      end),
      "compile_commands.json was not generated"
    )
    vim.cmd "bwipeout!"
  end)

  local clangd = vim.fn.exepath "clangd" ~= "" or vim.uv.fs_stat(vim.fn.stdpath "data" .. "/mason/bin/clangd")
  if not clangd then
    skipped[#skipped + 1] = "clangd finds the project headers (clangd not installed)"
  else
    test("clangd finds the project headers only with compile_commands.json", function()
      local function not_found(root)
        vim.cmd.cd(root)
        vim.cmd.edit(root .. "/src/main.c")
        vim.wait(15000, function()
          local c = vim.lsp.get_clients({ bufnr = 0, name = "clangd" })[1]
          -- Wait for clangd's diagnostics (norminette's arrive first)
          return c ~= nil
            and vim.iter(vim.diagnostic.get(0)):any(function(d)
              return d.source == "clang"
            end)
        end)
        local messages = vim.tbl_map(function(d)
          return d.message
        end, vim.diagnostic.get(0))
        vim.cmd "bwipeout!"
        return vim.iter(messages):any(function(m)
          return m:find("file not found", 1, true) ~= nil
        end),
          messages
      end

      vim.g.ft42_compile_db = false
      local without = tmp .. "/cdb_without"
      make_project(without)
      local missing, messages = not_found(without)
      assert(missing, "without compile_commands.json clangd should not find the headers: " .. vim.inspect(messages))

      -- Real flow: open a file, compile_commands.json is generated and clangd restarts with it
      vim.g.ft42_compile_db = nil
      local with = tmp .. "/cdb_with"
      make_project(with)
      vim.cmd.cd(with)
      vim.cmd.edit(with .. "/src/main.c")
      local function messages()
        return vim.tbl_map(function(d)
          return d.message
        end, vim.diagnostic.get(0))
      end
      local found = vim.wait(30000, function()
        local clang = vim.tbl_filter(function(d)
          return d.source == "clang"
        end, vim.diagnostic.get(0))
        return vim.uv.fs_stat(with .. "/compile_commands.json") ~= nil
          and #clang > 0
          and not vim.iter(clang):any(function(d)
            return d.message:find("file not found", 1, true) ~= nil
          end)
      end, 200)
      assert(found, "with compile_commands.json clangd should find the headers: " .. vim.inspect(messages()))
      vim.cmd "bwipeout!"
    end)
  end
end

vim.fn.delete(tmp, "rf")

for _, s in ipairs(skipped) do
  io.stdout:write("SKIP " .. s .. "\n")
end
if #failures > 0 then
  io.stderr:write(("FAILED %d/%d:\n- %s\n"):format(#failures, #failures + passed, table.concat(failures, "\n- ")))
  os.exit(1)
end
io.stdout:write(("OK (%d tests)\n"):format(passed))
os.exit(0)
