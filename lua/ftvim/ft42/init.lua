-- FtVim 42 tools: commands and autocommands (set up by the `lang.42` extra)

local M = {}

local function complete_files(arg_lead)
  return vim.fn.getcompletion(arg_lead, "file")
end

function M.setup()
  if M.did_setup then
    return
  end
  M.did_setup = true

  local command = vim.api.nvim_create_user_command

  command("FtVimExam", function(o)
    require("ftvim.ft42.exam").command(o.args)
  end, {
    nargs = "?",
    complete = function()
      return { "on", "off", "toggle" }
    end,
    desc = "Toggle exam mode (no LSP, completion, diagnostics, Copilot)",
  })

  command("FtVimCheck", function(o)
    require("ftvim.ft42.check").check(o.fargs)
  end, { nargs = "*", desc = "Pre-submission checks: norminette, Makefile, relink, forbidden functions" })

  command("FtVimNorm", function()
    require("ftvim.ft42.check").norm()
  end, { desc = "Run norminette on the project" })

  command("FtVimMake", function(o)
    require("ftvim.ft42.check").make(o.fargs)
  end, {
    nargs = "*",
    complete = function()
      return { "all", "clean", "fclean", "re", "bonus" }
    end,
    desc = "Run make and load errors into the quickfix list",
  })

  command("FtVimValgrind", function(o)
    require("ftvim.ft42.valgrind").run(o.fargs)
  end, { nargs = "*", complete = complete_files, desc = "Run the project under valgrind" })

  command("FtVimClass", function(o)
    require("ftvim.ft42.templates").create_class(o.args)
  end, { nargs = 1, desc = "Create a C++ class in Orthodox Canonical Form" })

  command("FtVimCompileDb", function()
    require("ftvim.ft42.compiledb").command()
  end, { desc = "Generate compile_commands.json with compiledb" })

  command("FtVimCompileFlags", function()
    require("ftvim.ft42.templates").write_compile_flags()
  end, { desc = "Write compile_flags.txt for clangd" })

  -- compile_commands.json: create it when opening a project, refresh it when the Makefile changes
  local compiledb_group = vim.api.nvim_create_augroup("ftvim_42_compiledb", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = compiledb_group,
    pattern = { "c", "cpp" },
    callback = function()
      require("ftvim.ft42.compiledb").auto()
    end,
  })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = compiledb_group,
    pattern = "Makefile",
    callback = function(event)
      require("ftvim.ft42.compiledb").on_makefile_write(event.match)
    end,
  })

  -- 42 header (and header guard) on new files
  vim.api.nvim_create_autocmd("BufNewFile", {
    group = vim.api.nvim_create_augroup("ftvim_42_templates", { clear = true }),
    pattern = { "*.c", "*.h", "*.cpp", "*.hpp", "*.tpp", "Makefile" },
    callback = function(event)
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(event.buf) and vim.api.nvim_get_current_buf() == event.buf then
          require("ftvim.ft42.templates").on_new_file(event.buf)
        end
      end)
    end,
  })
end

return M
