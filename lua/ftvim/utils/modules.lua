local M = {}

function M.require_on_exported_call(require_path)
	return setmetatable({}, {
		__index = function(_, k)
			return function(...)
				return require(require_path)[k](...)
			end
		end,
	})
end
return M
