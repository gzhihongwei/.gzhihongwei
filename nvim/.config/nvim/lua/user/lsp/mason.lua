-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
	pyright = {
		python = {
			analysis = {
				typeCheckingMode = "off",
			},
		},
	},
	-- tsserver = {},

	sumneko_lua = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			library = {
				[vim.fn.expand("$VIMRUNTIME/lua")] = true,
				[vim.fn.stdpath("config") .. "/lua"] = true,
			},
		},
	},
}

local handlers = require("user.lsp.handlers")

local capabilities = handlers.capabilities
local on_attach = handlers.on_attach

-- Setup mason so it can manage external tooling
local status_ok, mason = pcall(require, "mason")
if not status_ok then
	return
end

mason.setup()

-- Ensure the servers above are installed
local mason_lspconfig
status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
	return
end

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
		})
	end,
})
