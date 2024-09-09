local M = {}

local banner = {
	"                                                    		        ",
	"  (`/\\   ███████╗████████╗██╗   ██╗██╗███╗   ███╗    /\\')        ",
	"  `=\\/\\ ██╔════╝╚══██╔══╝██║   ██║██║████╗ ████║   /\\/='        ",
	"   `=\\/\\█████╗     ██║   ██║   ██║██║██╔████╔██║  /\\/='         ",
	"    `=\\/ ██╔══╝     ██║   ╚██╗ ██╔╝██║██║╚██╔╝██║  \\/='          ",
	"       \\ ██║        ██║    ╚████╔╝ ██║██║ ╚═╝ ██║  /              ",
	"          ╚═╝        ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝                 ",
}

function M.get_sections()
	local header = {
		type = "text",
		theme = "hyper",
		val = function()
			return banner
		end,
		opts = {
			position = "center",
			hl = "Label",
		},
	}

	local text = require("ftvim.interface.text")

	local footer = {
		type = "text",
		val = text.align_center({ width = 0 }, {
			"",
			"ftvim.github.io",
			"",
		}, 0.5),
		opts = {
			position = "center",
			hl = "Number",
		},
	}

	local buttons = {
		opts = {
			hl_shortcut = "Include",
			spacing = 1,
		},
		entries = {

			{ "f", ftvim.icons.ui.FindFile .. "  Find File", "<CMD>Telescope find_files<CR>" },
			{ "n", ftvim.icons.ui.NewFile .. "  New File", "<CMD>ene!<CR>" },
			-- { "s", ftvim.icons.ui.Forward .. "  Restore Session", "<CMD>lua require('persistence').load() <CR>" },
			{ "p", ftvim.icons.ui.Project .. "  Projects ", "<CMD>Telescope projects<CR>" },
			{ "r", ftvim.icons.ui.History .. "  Recent files", ":Telescope oldfiles <CR>" },
			{ "t", ftvim.icons.ui.FindText .. "  Find Text", "<CMD>Telescope live_grep<CR>" },
			{ "q", ftvim.icons.ui.Close .. "  Quit", "<CMD>quit<CR>" },
		},
	}
	return {
		header = header,
		buttons = buttons,
		footer = footer,
	}
end

return M
