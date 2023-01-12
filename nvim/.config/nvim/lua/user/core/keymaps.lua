-- [[ Basic Keymaps ]]
local keymap = vim.keymap.set

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
keymap("", "<Space>", "<Nop>")

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
keymap("i", "jk", "<ESC>")

keymap("n", "<leader>nh", ":nohl<CR>", { desc = "[N]o [H]ighlighting" })

keymap("n", "x", '"_x')

keymap("n", "<leader>+", "<C-a>")
keymap("n", "<leader>-", "<C-x>")

keymap("n", "<leader>vs", "<C-w>v", { desc = "[V]ertically [S]plit window" })
keymap("n", "<leader>hs", "<C-w>s", { desc = "[H]orizontally [S]plit window" })
keymap("n", "<leader>es", "<C-w>=", { desc = "[E]qual width [S]plit windows" })
keymap("n", "<leader>xs", ":close<CR>", { desc = "E[x]it current [S]plit window" })

keymap("n", "<leader>to", ":tabnew<CR>", { desc = "[T]ab [O]pen" })
keymap("n", "<leader>tx", ":tabclose<CR>", { desc = "[T]ab E[x]it" })
keymap("n", "<leader>tn", ":tabn<CR>", { desc = "[T]ab [N]ext" })
keymap("n", "<leader>tp", ":tabp<CR>", { desc = "[T]ab [P]revious" })

keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- See `:help telescope.builtin`
keymap("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
keymap("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
keymap("n", "<leader>/", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })

keymap("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
keymap("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
keymap("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
keymap("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
keymap("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })

-- Nvim-tree
keymap("n", "<leader>t", ":NvimTreeToggle<CR>", { desc = "[T]oggle file tree" })
keymap("n", "<leader>f", ":NvimTreeFocus<CR>", { desc = "[F]ocus on file tree" })
