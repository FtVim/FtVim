local M = {}

local function _assign(old, new, k)
	local otype = type(old[k])
	local ntype = type(new[k])
	if (otype == "thread" or otype == "userdata") or (ntype == "thread" or ntype == "userdata") then
		vim.notify(string.format("warning: old or new attr %s type be thread or userdata", k))
	end
	old[k] = new[k]
end

local function _replace(old, new, repeat_tbl)
	if repeat_tbl[old] then
		return
	end
	repeat_tbl[old] = true

	local dellist = {}
	for k, _ in pairs(old) do
		if not new[k] then
			table.insert(dellist, k)
		end
	end
	for _, v in ipairs(dellist) do
		old[v] = nil
	end

	for k, _ in pairs(new) do
		if not old[k] then
			old[k] = new[k]
		else
			if type(old[k]) ~= type(new[k]) then
				_assign(old, new, k)
			else
				if type(old[k]) == "table" then
					_replace(old[k], new[k], repeat_tbl)
				else
					_assign(old, new, k)
				end
			end
		end
	end
end

M.require_clean = function(m)
	package.loaded[m] = nil
	_G[m] = nil
	local _, module = pcall(require, m)
	return module
end

M.require_safe = function(mod)
	local status_ok, module = pcall(require, mod)
	if not status_ok then
		local trace = debug.getinfo(2, "SL")
		local shorter_src = trace.short_src
		local lineinfo = shorter_src .. ":" .. (trace.currentline or trace.linedefined)
		local msg = string.format("%s : skipped loading [%s]", lineinfo, mod)
	end
	return module
end

M.reload = function(mod)
	if not package.loaded[mod] then
		return M.require_safe(mod)
	end

	local old = package.loaded[mod]
	package.loaded[mod] = nil
	local new = M.require_safe(mod)

	if type(old) == "table" and type(new) == "table" then
		local repeat_tbl = {}
		_replace(old, new, repeat_tbl)
	end

	package.loaded[mod] = old
	return old
end

function M.require_on_exported_call(require_path)
	return setmetatable({}, {
		__index = function(_, k)
			return function(...)
				return require(require_path)[k](...)
			end
		end,
	})
end

local map = vim.keymap.set

function M.learn_to_move()
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

return M
