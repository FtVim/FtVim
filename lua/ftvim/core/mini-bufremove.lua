local M = {}

M.config = function()
	keys = {
		{
			"<leader>bd",
			function()
				local bd = require("mini.bufremove").delete
				if vim.bo.modified then
					local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
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
		-- stylua: ignore
		{ "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
	},
end

M.setup = function()
	local status_ok, mini-bufremove = pcall(require, "mini-bufremove")
	if not status_ok then
		return
	end

	mini-bufremove.setup(ftvim.builtin.mini-bufremove.options)

	if ftvim.builtin.mini-bufremove.on_config_done then
		ftvim.builtin.mini-bufremove.on_config_done()
	end
end

return M
