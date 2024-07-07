local M = {}

function M.config()
	ftvim.builtin.autopairs = {
		active = true,
		on_config_done = nil,
		---@usage  modifies the function or method delimiter by filetypes
		map_char = {
			all = "(",
			tex = "{",
		},
		---@usage check bracket in same line
		enable_check_bracket_line = false,
		---@usage check treesitter
		check_ts = true,
		ts_config = {
			lua = { "string", "source" },
			javascript = { "string", "template_string" },
			java = false,
		},
		disable_filetype = { "TelescopePrompt", "spectre_panel" },
		---@usage disable when recording or executing a macro
		disable_in_macro = false,
		---@usage disable  when insert after visual block mode
		disable_in_visualblock = false,
		disable_in_replace_mode = true,
		ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
		enable_moveright = true,
		---@usage add bracket pairs after quote
		enable_afterquote = true,
		---@usage trigger abbreviation
		enable_abbr = false,
		---@usage switch for basic rule break undo sequence
		break_undo = true,
		map_cr = true,
		---@usage map the <BS> key
		map_bs = true,
		---@usage map <c-w> to delete a pair if possible
		map_c_w = false,
		---@usage Map the <C-h> key to delete a pair
		map_c_h = false,
		---@usage  change default fast_wrap
		fast_wrap = {
			map = "<M-e>",
			chars = { "{", "[", "(", '"', "'" },
			pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
			offset = 0, -- Offset from pattern match
			end_key = "$",
			keys = "qwertyuiopzxcvbnmasdfghjkl",
			check_comma = true,
			highlight = "Search",
			highlight_grey = "Comment",
		},
	}
end

M.setup = function()
	local status_ok, autopairs = pcall(require, "nvim-autopairs")
	if not status_ok then
		print ("Error loading autopairs")
		return
	end

	autopairs.setup({
		check_ts = ftvim.builtin.autopairs.check_ts,
		enable_check_bracket_line = ftvim.builtin.autopairs.enable_check_bracket_line,
		ts_config = ftvim.builtin.autopairs.ts_config,
		disable_filetype = ftvim.builtin.autopairs.disable_filetype,
		disable_in_macro = ftvim.builtin.autopairs.disable_in_macro,
		ignored_next_char = ftvim.builtin.autopairs.ignored_next_char,
		enable_moveright = ftvim.builtin.autopairs.enable_moveright,
		enable_afterquote = ftvim.builtin.autopairs.enable_afterquote,
		map_c_w = ftvim.builtin.autopairs.map_c_w,
		map_bs = ftvim.builtin.autopairs.map_bs,
		disable_in_visualblock = ftvim.builtin.autopairs.disable_in_visualblock,
		fast_wrap = ftvim.builtin.autopairs.fast_wrap,
	})

	if ftvim.builtin.autopairs.on_config_done then
		ftvim.builtin.autopairs.on_config_done(autopairs)
	end

	pcall(function()
		local function on_confirm_done(...)
			require("nvim-autopairs.completion.cmp").on_confirm_done()(...)
		end
		require("cmp").event:off("confirm_done", on_confirm_done)
		require("cmp").event:on("confirm_done", on_confirm_done)
	end)
end

return M
