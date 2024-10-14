local M = {}

M.config = {
	enable = true,
	keys = {
		{
			"<leader>bd",
			function()
				local bd = require("mini.bufremove").delete
				if vim.bo.modified then
					local choice =
					vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
					if choice == 1 then -- Yes
						vim.cmd.write()
						bd(0)
					elseif choice == 2 then -- No
						bd(0, true)
					end
				else
					bd(0)
				end
			end,
			desc = "Delete Buffer",
		},
		{
			"<leader>bD",
			function()
				require("mini.bufremove").delete(0, true)
			end,
			desc = "Delete Buffer (Force)",
		},
	},
}

M.setup = function()
	local status_ok, mini_bufremove = pcall(require, "mini_bufremove")
	if not status_ok then
		return
	end

	mini_bufremove.setup(M.config)

end

return M
