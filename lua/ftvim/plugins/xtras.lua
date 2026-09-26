-- Extras enabled with :FtVimExtras (stored in stdpath("config")/ftvim.json)

local root = require("ftvim.util").root() .. "/lua/"
local imports = {}

for _, module in ipairs(require("ftvim.extras").read().extras) do
  -- Skip extras that no longer exist instead of breaking startup
  if vim.uv.fs_stat(root .. module:gsub("%.", "/") .. ".lua") then
    imports[#imports + 1] = { import = module }
  else
    vim.schedule(function()
      vim.notify("FtVim: extra " .. module .. " not found (see :FtVimExtras)", vim.log.levels.WARN)
    end)
  end
end

return imports
