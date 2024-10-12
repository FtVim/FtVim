return {

  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", 
      "MunifTanjim/nui.nvim",
    }
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
	    {
		    "<leader>?",
		    function()
			    require("which-key").show({ global = false })
		    end,
		    desc = "Buffer Local Keymaps (which-key)",
	    },
  },
  },
}
