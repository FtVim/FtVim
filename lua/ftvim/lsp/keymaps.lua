-- FtVim LSP keymaps (buffer-local, set when a server attaches)

local M = {}

---@class FtVimLspKey
---@field [1] string lhs
---@field [2] fun() rhs
---@field desc string
---@field mode? string|string[]
---@field has? string LSP method the server must support

---@type FtVimLspKey[]
M.keys = {
  { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
  { "gr", vim.lsp.buf.references, desc = "References" },
  { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
  { "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
  { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
  { "K", vim.lsp.buf.hover, desc = "Hover" },
  { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
  { "<leader>cd", vim.lsp.buf.definition, desc = "Goto Definition" },
  { "<leader>ci", vim.lsp.buf.implementation, desc = "Goto Implementation" },
  { "<leader>cs", vim.lsp.buf.signature_help, desc = "Signature Help" },
  { "<leader>ct", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
  { "<leader>cv", vim.lsp.buf.hover, desc = "Hover" },
  {
    "<leader>ch",
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
    end,
    desc = "Toggle Inlay Hints",
    has = "textDocument/inlayHint",
  },
}

---@param client vim.lsp.Client
---@param buffer integer
function M.on_attach(client, buffer)
  for _, key in ipairs(M.keys) do
    if not key.has or client:supports_method(key.has, buffer) then
      vim.keymap.set(key.mode or "n", key[1], key[2], { buffer = buffer, desc = "LSP: " .. key.desc })
    end
  end
end

return M
