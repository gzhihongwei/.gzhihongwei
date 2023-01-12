local lspconfig = require("user.plugins.lsp.lspconfig")

-- Setup mason so it can manage external tooling
local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
	return
end

-- Ensure the LSP servers are installed
local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
	return
end

-- Ensure formatter and linters are installed
local mason_null_ls_status_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status_ok then
	return
end

mason.setup()

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(lspconfig.lsp_servers),
	automatic_installation = true,
})

mason_null_ls.setup({
	ensure_installed = lspconfig.formatters_and_linters,
	automatic_installation = true,
})
