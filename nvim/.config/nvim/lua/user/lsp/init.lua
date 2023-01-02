local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require("user.lsp.mason")
require("user.lsp.handlers").setup()
require("user.lsp.null-ls")
require("user.lsp.lsp_signature")
require("user.lsp.fidget")
require("user.lsp.cmp")
require("user.lsp.neodev")