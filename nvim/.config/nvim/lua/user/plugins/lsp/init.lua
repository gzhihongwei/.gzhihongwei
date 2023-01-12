local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("user.plugins.lsp.fidget")
require("user.plugins.lsp.lspconfig").setup()
require("user.plugins.lsp.lspsaga")
require("user.plugins.lsp.mason")
require("user.plugins.lsp.null-ls")
