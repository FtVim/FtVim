return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		require("ftvim.core.nvimtree").setup()
	end,
	enabled = ftvim.builtin.nvimtree.active,
	cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFileToggle" },
	event = "User DirOpened",
}
