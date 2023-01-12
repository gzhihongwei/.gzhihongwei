local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
	return
end

local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
	return
end

local M = {}

M.lsp_servers = {
	pyright = {
		python = {
			analysis = {
				typeCheckingMode = "off",
			},
		},
	},
	html = {},
	cssls = {},
	emmet_ls = {
		filetypes = { "html", "typescriptreact", "javascriptreact", "css" },
	},
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

M.formatters_and_linters = {
	"prettier",
	"stylua",
	"black",
	"flake8",
	"eslint_d",
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

M.setup = function()
	local signs = {
		Error = "",
		Warn = "",
		Hint = "",
		Info = "",
	}

	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numl = "" })
	end

	local diagnostic_config = {
		-- disable virtual text
		virtual_text = false,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(diagnostic_config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})

	mason_lspconfig.setup_handlers({
		function(server_name)
			local server_config =
				{ capabilities = capabilities, on_attach = M.on_attach, settings = M.lsp_servers[server_name] }
			if server_config.settings ~= nil and server_config.settings.filetypes ~= nil then
				server_config.filetypes = server_config.settings.filetypes
				server_config.settings.filetypes = nil
			end
			require("lspconfig")[server_name].setup(server_config)
		end,
	})
end

local function lsp_keymaps(client, bufnr)
	-- NOTE: Remember that lua is a real programming language, and as such it is possible
	-- to define small helper and utility functions so you don't have to repeat yourself
	-- many times.
	--
	-- In this case, we create a function that lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { noremap = true, silent = true, buffer = bufnr, desc = desc })
	end

	nmap("<leader>rn", ":Lspsaga rename<CR>", "[R]e[n]ame")
	nmap("<leader>ca", ":Lspsaga code_action<CR>", "[C]ode [A]ction")

	nmap("gd", ":Lspsaga peek_definition<CR>", "[G]oto [D]efinition")
	nmap("gr", ":Lspsaga lsp_finder<CR>", "[G]oto [R]eferences")
	nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>D", ":Lspsaga show_line_diagnostics<CR>", "Line [D]iagnostics")
	nmap("<leader>d", ":Lspsaga show_cursor_diagnostics<CR>", "Cursor [D]iagnostics")
	nmap("[d", ":Lspsaga diagnostic_jump_prev<CR>", "Previous Diagnostic")
	nmap("]d", ":Lspsaga diagnostic_jump_next<CR>", "Next Diagnostic")
	nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	nmap("K", ":Lspsaga hover_doc", "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
	nmap("<leader>o", ":LSoutlineToggle", "Toggle [O]utline")

	-- Lesser used LSP functionality
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
	nmap("<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		nmap("<leader>rf", ":TypescriptRenameFile<CR>", "[R]ename [F]ile")
		nmap("<leader>oi", ":TypescriptOrganizeImports<CR>", "[O]rganize [I]mports")
		nmap("<leader>ru", ":TypescriptRemoveUnused<CR>", "[R]emove [U]nused Variables")
	end
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]],
			false
		)
	end
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(client, bufnr)
	lsp_highlight_document(client)
end

return M
