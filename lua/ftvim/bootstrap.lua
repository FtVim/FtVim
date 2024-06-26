local M = {}

if vim.fn.has("nvim-0.9.0") == 0 then
	vim.api.nvim_echo({
		{ "FtVim requires Neovim >= 0.9.0\n", "ErrorMsg" },
		{ "Press any key to exit", "MoreMsg" },
	}, true, {})
	vim.fn.getchar()
	vim.cmd([[quit]])
	return {}
end

local uv = vim.loop
local path_sep = uv.os_uname().version:match("Windows") and "\\" or "/"

function _G.join_paths(...)
	local result = table.concat({ ... }, path_sep)
	return result
end

_G.require_clean = require("ftvim.utils.modules").require_clean
_G.require_safe = require("ftvim.utils.modules").require_safe
_G.reload = require("ftvim.utils.modules").reload

function _G.get_runtime_dir()
	return vim.call("stdpath", "data")
end

function _G.get_config_dir()
	return vim.call("stdpath", "config")
end

function _G.get_cache_dir()
	return vim.call("stdpath", "cache")
end

function M:init(base_dir)
	self.runtime_dir = get_runtime_dir()
	self.config_dir = get_config_dir()
	self.cache_dir = get_cache_dir()
	self.pack_dir = join_paths(self.runtime_dir, "site", "pack")
	self.lazy_install_dir = join_paths(self.pack_dir, "lazy", "opt", "lazy.nvim")

	vim.fn.stdpath = function(what)
		if what == "cache" then
			return _G.get_cache_dir()
		end
		return vim.call("stdpath", what)
	end

	function _G.get_ftvim_base_dir()
		return base_dir
	end

	require("ftvim.config"):init()

	return self
end
