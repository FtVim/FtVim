local base_dir = function()
	local init_path = debug.getinfo(1, "S").source
	return init_path:sub(2):match("(.*[/\\])"):sub(1, -2)
end

if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
	vim.opt.rtp:prepend(base_dir)
end

require("ftvim.bootstrap"):init(base_dir)
