local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

-- Recommended settings from nvim-tree documentation
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

nvim_tree.setup({
	disable_netrw = true,
	hijack_netrw = true,
	ignore_ft_on_setup = {
		"startify",
		"dashboard",
		"alpha",
	},
	open_on_tab = false,
	hijack_cursor = false,
	sync_root_with_cwd = true,
	hijack_directories = {
		enable = true,
		auto_open = true,
	},
	diagnostics = {
		enable = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = true,
		update_root = false,
		ignore_list = { "toggleterm", "fugitive" },
	},
	git = {
		enable = true,
		ignore = true,
		show_on_dirs = true,
		timeout = 400,
	},
	view = {
		width = 30,
		hide_root_folder = false,
		side = "left",
		number = false,
		relativenumber = false,
	},
	actions = {
		open_file = {
			quit_on_open = false,
			resize_window = true,
		},
	},
	renderer = {
		root_folder_modifier = ":t",
		icons = {
			git_placement = "after",
			show = {
				git = true,
				folder = true,
				file = true,
				folder_arrow = true,
			},
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_closed = "",
					arrow_open = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
				},
				git = {
					unstaged = "M",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					deleted = "",
					untracked = "U",
					ignored = "◌",
				},
			},
		},
	},
	filters = {
		custom = { "node_modules", "^.git$" },
	},
})
