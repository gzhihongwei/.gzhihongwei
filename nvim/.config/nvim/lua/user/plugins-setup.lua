local fn = vim.fn
-- Auto install packer if not installed
local ensure_packer = function()
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if packer_bootstrap then
	print("==================================")
	print("    Plugins are being installed")
	print("    Wait until Packer completes,")
	print("       then restart nvim")
	print("==================================")
	return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	command = "source <afile> | PackerSync",
	group = packer_group,
	pattern = "plugins-setup.lua",
})

-- Use a protected call so we don't error on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

packer.startup(function(use)
	-- Package manager
	use("wbthomason/packer.nvim")

	-- Lua functions that many plugins use
	use("nvim-lua/plenary.nvim")

	-- Aesthetics & functionality
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("kyazdani42/nvim-web-devicons") -- Better icons
	use("kyazdani42/nvim-tree.lua") -- File navigator
	use("romgrk/barbar.nvim") -- Better tabs
	use("akinsho/toggleterm.nvim") -- Toggle terminal
	use("rcarriga/nvim-notify") -- Better notifications
	use("projekt0n/github-nvim-theme") -- GitHub dark theme
	use("nvim-lualine/lualine.nvim") -- Fancier statusline
	use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines

	-- Commenting
	use("numToStr/Comment.nvim") -- "gc" to comment visual regions/lines
	use("JoosepAlviste/nvim-ts-context-commentstring") -- Adds support for commenting in react

	-- Fuzzy Finder (files, lsp, etc)
	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
	})
	-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = fn.executable("make") == 1 })

	-- Autocompletion
	use("hrsh7th/nvim-cmp") -- Completion plugin
	use("hrsh7th/cmp-buffer") -- Source for text in buffer
	use("hrsh7th/cmp-path") -- Source for file system paths

	-- Snippets
	use("L3MON4D3/LuaSnip") -- Snippet engine
	use("saadparwaiz1/cmp_luasnip") -- For autocompletion
	use("rafamadriz/friendly-snippets") -- Useful snippets

	-- LSP Servers, Linters, & Formatters managing & installation
	use("williamboman/mason.nvim") -- In charge of managing LSP Servers, Linters, & Formatters
	use("williamboman/mason-lspconfig.nvim") -- Bridges gap between mason & lspconfig

	-- LSP Configuration
	use("neovim/nvim-lspconfig") -- Easily configure language servers
	use("j-hui/fidget.nvim") -- Useful status updates for LSP
	use("hrsh7th/cmp-nvim-lsp") -- For autocompletion
	use({ "glepnir/lspsaga.nvim", branch = "main" }) -- Enhanced LSP UI
	use("onsails/lspkind.nvim") -- VS Code like icons for autocompletion

	-- Formatting & Linting
	use("jose-elias-alvarez/null-ls.nvim") -- Configure formatters & linters
	use("jayp0521/mason-null-ls.nvim") -- Bridges gap between mason & null-ls

	-- TreeSitter
	use({ -- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use({ -- Additional text objects via treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
	})

	-- Pairs
	use("p00f/nvim-ts-rainbow") -- Bracket Pair Colorizer
	use("windwp/nvim-autopairs") -- Autoclose parens, brackets, quotes, etc.
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- Autoclose tags
	use("abecodes/tabout.nvim") -- Tab out of opening and closing delimitters
	use("kylechui/nvim-surround") -- Better surrounding delimitter changes

	-- Git related plugins
	use("tpope/vim-fugitive") -- Git integration
	use("lewis6991/gitsigns.nvim") -- Git gutter

	if packer_bootstrap then
		require("packer").sync()
	end
end)
