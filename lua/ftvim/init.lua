if vim.fn.has "nvim-0.10" ~= 0 then
  vim.notify("Please upgrade your Neovim base installation. Lunarvim requires v0.10+", vim.log.levels.WARN)
  vim.wait(5000, function()
    ---@diagnostic disable-next-line: redundant-return-value
    return false
  end)
  vim.cmd "cquit"
end

require("ftvim.bootstrap"):init()
