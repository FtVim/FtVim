-- Exam mode: practice in exam conditions (no LSP, completion, AI, diagnostics or autopairs)

local util = require "ftvim.ft42.util"

local M = {}

M.enabled = false

local augroup = vim.api.nvim_create_augroup("ftvim_exam", { clear = true })

function M.enable()
  if M.enabled then
    return
  end
  M.enabled = true
  vim.g.ftvim_completion = false
  vim.g.ftvim_lint = false

  -- Stop running servers and detach any that start while in exam mode
  for _, client in ipairs(vim.lsp.get_clients()) do
    client:stop()
  end
  vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client then
        vim.schedule(function()
          client:stop()
        end)
      end
    end,
  })

  vim.diagnostic.enable(false)
  pcall(function()
    require("blink.cmp").hide()
  end)
  if package.loaded["nvim-autopairs"] then
    require("nvim-autopairs").disable()
  end
  if package.loaded.copilot then
    pcall(vim.cmd, "Copilot disable")
  end

  util.notify "Exam mode ON: LSP, completion, diagnostics, Copilot and autopairs are disabled.\nGood luck!"
  vim.cmd.redrawstatus()
end

function M.disable()
  if not M.enabled then
    return
  end
  M.enabled = false
  vim.g.ftvim_completion = nil
  vim.g.ftvim_lint = nil
  vim.api.nvim_clear_autocmds { group = augroup }

  vim.diagnostic.enable(true)
  if package.loaded["nvim-autopairs"] then
    require("nvim-autopairs").enable()
  end
  if package.loaded.copilot then
    pcall(vim.cmd, "Copilot enable")
  end
  util.reattach_lsp()
  if package.loaded.lint then
    require("lint").try_lint()
  end

  util.notify "Exam mode OFF"
  vim.cmd.redrawstatus()
end

function M.toggle()
  if M.enabled then
    M.disable()
  else
    M.enable()
  end
end

---@param arg? "on"|"off"|"toggle"|""
function M.command(arg)
  if arg == "on" then
    M.enable()
  elseif arg == "off" then
    M.disable()
  else
    M.toggle()
  end
end

return M
