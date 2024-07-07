local M = {}

M.config = function()
	vim.g.persistence_opts = {
		dir = vim.fn.expand(vim.fn.stdpath('data') .. '/sessions/'), -- Aseguramos que el campo 'dir' esté definido
		options = vim.opt.sessionoptions:get(),
	}
end

M.setup = function()
	local status_ok, persistence = pcall(require, "persistence")
	if not status_ok then
		print("Error loading persistence.nvim")
		return
	end

	-- Depuración: Imprimir la configuración de 'opts'
	print("Configuración de persistence: " .. vim.inspect(vim.g.persistence_opts))

	if not vim.g.persistence_opts.dir then
		print("Error: 'dir' no está definido en persistence.opts")
	end

	persistence.setup(vim.g.persistence_opts)
end

return M

