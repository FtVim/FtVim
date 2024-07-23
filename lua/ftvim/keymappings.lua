local config = require('ftvim.config.defaults')

local M = {}

local generic_opts_any = { noremap = true, silent = true }

local map = vim.keymap.set

local generic_opts = {
	insert_mode = generic_opts_any,
	normal_mode = generic_opts_any,
	visual_mode = generic_opts_any,
	visual_block_mode = generic_opts_any,
	command_mode = generic_opts_any,
	operator_pending_mode = generic_opts_any,
	term_mode = { silent = true },
}

local mode_adapters = {
	insert_mode = "i",
	normal_mode = "n",
	term_mode = "t",
	visual_mode = "v",
	visual_block_mode = "x",
	command_mode = "c",
	operator_pending_mode = "o",
}

local defaults = {
	insert_mode = {
		-- Move current line / block with Alt-j/k ala vscode.
		["<A-j>"] = "<Esc>:m .+1<CR>==gi",

		-- Move current line / block with Alt-j/k ala vscode.
		["<A-k>"] = "<Esc>:m .-2<CR>==gi",
	},

	normal_mode = {
		-- Clear search with <esc>
		["<esc>"] = "<cmd>nohlsearch<CR>",

		-- Buffers
		["<S-h>"] = "<cmd>bprevious<cr>",
		["<S-l>"] = "<cmd>bnext<cr>",

		-- Better window movement
		["<C-h>"] = "<C-w>h",
		["<C-j>"] = "<C-w>j",
		["<C-k>"] = "<C-w>k",
		["<C-l>"] = "<C-w>l",

		-- Move current line / block with Alt-j/k a la vscode.
		["<A-j>"] = ":m .+1<CR>==",
		["<A-k>"] = ":m .-2<CR>==",

	},

	term_mode = {
		-- Terminal window navigation
		["<C-h>"] = "<C-\\><C-N><C-w>h",
		["<C-j>"] = "<C-\\><C-N><C-w>j",
		["<C-k>"] = "<C-\\><C-N><C-w>k",
		["<C-l>"] = "<C-\\><C-N><C-w>l",
	},

	visual_mode = {
		-- Better indenting
		["<"] = "<gv",
		[">"] = ">gv",

		-- ["p"] = '"0p',
		-- ["P"] = '"0P',
	},

	visual_block_mode = {
		-- Move current line / block with Alt-j/k ala vscode.
		["<A-j>"] = ":m '>+1<CR>gv-gv",
		["<A-k>"] = ":m '<-2<CR>gv-gv",
	},

	command_mode = {
		-- navigate tab completion with <c-j> and <c-k>
		-- runs conditionally
		["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
		["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
	},
}

if vim.fn.has("mac") == 1 then
	defaults.normal_mode["<A-Up>"] = defaults.normal_mode["<C-Up>"]
	defaults.normal_mode["<A-Down>"] = defaults.normal_mode["<C-Down>"]
	defaults.normal_mode["<A-Left>"] = defaults.normal_mode["<C-Left>"]
	defaults.normal_mode["<A-Right>"] = defaults.normal_mode["<C-Right>"]
end

local function add_learn_to_move_keymaps()
    return {
		map("n", "<left>", function()
			vim.notify("Use h to move!!", "Error", { title = "Learn to move"})
		end),
		map("n", "<right>",  function()
			vim.notify("Use l to move!!", "Error", { title = "Learn to move"})
		end),
		map("n", "<up>",  function()
			vim.notify("Use k to move!!", "Error", { title = "Learn to move"})
		end),
		map("n", "<down>",  function()
			vim.notify("Use j to move!!", "Error", { title = "Learn to move"})
		end),
    }
end

function M.clear(keymaps)
	local default = M.get_defaults()
	for mode, mappings in pairs(keymaps) do
		local translated_mode = mode_adapters[mode] and mode_adapters[mode] or mode
		for key, _ in pairs(mappings) do
			-- some plugins may override default bindings that the user hasn't manually overriden
			if
				default[mode][key] ~= nil or (default[translated_mode] ~= nil and default[translated_mode][key] ~= nil)
			then
				pcall(vim.api.nvim_del_keymap, translated_mode, key)
			end
		end
	end
end

function M.set_keymaps(mode, key, val)
	local opt = generic_opts[mode] or generic_opts_any
	if type(val) == "table" then
		opt = val[2]
		val = val[1]
	end
	if val then
		vim.keymap.set(mode, key, val, opt)
	else
		pcall(vim.api.nvim_del_keymap, mode, key)
	end
end

function M.load_mode(mode, keymaps)
	mode = mode_adapters[mode] or mode
	for k, v in pairs(keymaps) do
		M.set_keymaps(mode, k, v)
	end
end

function M.load(keymaps)
	keymaps = keymaps or {}
	for mode, mapping in pairs(keymaps) do
		M.load_mode(mode, mapping)
	end
end

function M.load_defaults()
    local default_keymaps = M.get_defaults()

    if config.learn_to_move then
        local learn_to_move_keymaps = add_learn_to_move_keymaps()
        for key, value in pairs(learn_to_move_keymaps) do
            default_keymaps.normal_mode[key] = value
        end
    end

    M.load(default_keymaps)
    ftvim.keys = ftvim.keys or {}
    for idx, _ in pairs(default_keymaps) do
        if not ftvim.keys[idx] then
            ftvim.keys[idx] = {}
        end
    end
end

function M.get_defaults()
	return defaults
end

return M
