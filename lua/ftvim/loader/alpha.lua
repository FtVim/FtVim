local M = {}

local function max_len_line(lines)
	local max_len = 0

	for _, line in ipairs(lines) do
		local line_len = line:len()
		if line_len > max_len then
			max_len = line_len
		end
	end

	return max_len
end

local function align_center(container, lines, alignment)
	local output = {}
	local max_len = max_len_line(lines)

	for _, line in ipairs(lines) do
		local padding = string.rep(" ", (math.max(container.width, max_len) - line:len()) * alignment)
		table.insert(output, padding .. line)
	end

	return output
end

local function footer()
  local plugins_count = require("lazy").stats().loaded
  local datetime = os.date("  %m-%d-%Y   %H:%M:%S")
  local version = vim.version()
  local nvim_version_info = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch
  return datetime .. "   Plugins " .. plugins_count .. nvim_version_info 
end


M.setup = function()
	local dashboard = require("alpha.themes.dashboard")
	local logo = [[
    ███████████ ███████████ █████   █████ █████ ██████   ██████
   ░░███░░░░░░█░█░░░███░░░█░░███   ░░███ ░░███ ░░██████ ██████ 
    ░███   █ ░ ░   ░███  ░  ░███    ░███  ░███  ░███░█████░███ 
    ░███████       ░███     ░███    ░███  ░███  ░███░░███ ░███ 
    ░███░░░█       ░███     ░░███   ███   ░███  ░███ ░░░  ░███ 
    ░███  ░        ░███      ░░░█████░    ░███  ░███      ░███ 
    █████          █████       ░░███      █████ █████     █████
   ░░░░░          ░░░░░         ░░░      ░░░░░ ░░░░░     ░░░░░  
	]]
	local icons = require("ftvim.config").icons

	dashboard.section.header.val = vim.split(logo, "\n")
	-- stylua: ignore
	dashboard.section.buttons.val = {
		dashboard.button("f", " " .. " Find file",       "<CMD>Telescope find_files<CR>"),
		dashboard.button("n", " " .. " New file",        [[<CMD> ene <BAR> startinsert <cr>]]),
		dashboard.button("r", " " .. " Recent files",    "<CMD>Telescope oldfiles <CR>"),
		dashboard.button("p", icons.ui.Project .. "  Projects ", "<CMD>Telescope projects<CR>"),
		dashboard.button("t", icons.ui.FindText .. "  Find Text", "<CMD>Telescope live_grep<CR>"),
		dashboard.button("s", " " .. " Restore Session", [[<CMD> lua require("persistence").load() <cr>]]),
		dashboard.button("l", "󰒲 " .. " Lazy",            "<CMD> Lazy <cr>"),
		dashboard.button("q", " " .. " Quit",            "<CMD> qa <cr>"),
	}
	for _, button in ipairs(dashboard.section.buttons.val) do
		button.opts.hl = "AlphaButtons"
		button.opts.hl_shortcut = "AlphaShortcut"
	end
	dashboard.section.footer.val = align_center({ width = 0}, {footer(), "ftvim.github.io", ""}, 0.45)
	dashboard.section.footer.opts.hl = "CursorLineNr"
	dashboard.section.buttons.opts.hl = "LineNr"

	dashboard.opts.layout[1].val = 8
	require("alpha").setup(dashboard.opts)
end

return M
