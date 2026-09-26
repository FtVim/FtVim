-- Minimal init to load this checkout of FtVim in an isolated environment.
-- Usage:
--   nvim --headless -u tests/minimal_init.lua "+Lazy! sync" +qa
--   nvim --headless -u tests/minimal_init.lua "+luafile tests/smoke.lua"
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local test_home = root .. "/.tests"
for _, name in ipairs { "config", "data", "state", "cache" } do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = test_home .. "/" .. name
end

-- Record every global keymap so tests/keymaps.lua can detect conflicts
_G.FTVIM_KEYMAP_LOG = {}
local keymap_set = vim.keymap.set
vim.keymap.set = function(mode, lhs, rhs, opts)
  if not (opts and opts.buffer) then
    local info = debug.getinfo(2, "S")
    for _, m in ipairs(type(mode) == "table" and mode or { mode }) do
      table.insert(_G.FTVIM_KEYMAP_LOG, { mode = m, lhs = lhs, desc = opts and opts.desc, source = info.short_src })
    end
  end
  return keymap_set(mode, lhs, rhs, opts)
end

local lazypath = test_home .. "/data/nvim/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  spec = {
    { dir = root, name = "FtVim", import = "ftvim.plugins" },
    { import = "ftvim.plugins.extras.lang.42" },
    { import = "ftvim.plugins.extras.lang.rails" },
    { import = "ftvim.plugins.extras.lang.cpp" },
    { import = "ftvim.plugins.extras.lang.docker" },
    { import = "ftvim.plugins.extras.lang.web" },
  },
  install = { colorscheme = { "habamax" } },
  change_detection = { enabled = false },
}
