if vim.fn.has("nvim-0.9") ~= 1 then
	vim.notify("Please upgrade your Neovim base installation. FtVim requires v0.9+", vim.log.levels.WARN)
	vim.wait(5000, function()
		---@diagnostic disable-next-line: redundant-return-value
		return false
	end)
	vim.cmd("cquit")
end

require("ftvim.config"):init()

return {
	{ "folke/lazy.nvim", version = "*" },
	{ "FtVim/FtVim", priority = 10000, lazy = false, version = "*" },
}
