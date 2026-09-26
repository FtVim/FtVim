-- Detects global keymaps defined twice with different descriptions (i.e. two features fighting
-- for the same key). Run: nvim --headless -u tests/minimal_init.lua "+luafile tests/keymaps.lua"

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = vim.schedule_wrap(function()
    vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
    vim.wait(2000, function()
      return package.loaded["which-key"] and require("which-key.config").loaded
    end)

    local leader = vim.g.mapleader or "\\"
    local function norm(lhs)
      return (vim.fn.keytrans(vim.keycode((lhs:gsub("<[lL]eader>", leader)))))
    end

    local by_key = {}
    for _, map in ipairs(_G.FTVIM_KEYMAP_LOG or {}) do
      -- Ignore plugin-internal mappings without a description
      if map.desc then
        local key = map.mode .. " " .. norm(map.lhs)
        by_key[key] = by_key[key] or {}
        by_key[key][map.desc] = map.source
      end
    end

    local conflicts = {}
    for key, descs in pairs(by_key) do
      if vim.tbl_count(descs) > 1 then
        local list = {}
        for desc, source in pairs(descs) do
          list[#list + 1] = ("%q (%s)"):format(desc, source)
        end
        table.sort(list)
        conflicts[#conflicts + 1] = key .. ": " .. table.concat(list, " vs ")
      end
    end
    table.sort(conflicts)

    if #conflicts > 0 then
      io.stderr:write("Keymap conflicts:\n- " .. table.concat(conflicts, "\n- ") .. "\n")
      os.exit(1)
    end
    io.stdout:write(("OK (%d keymaps)\n"):format(#(_G.FTVIM_KEYMAP_LOG or {})))
    os.exit(0)
  end),
})
