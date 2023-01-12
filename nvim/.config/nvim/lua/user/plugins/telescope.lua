-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local telescope_status_ok, telescope = pcall(require, "telescope")
if not telescope_status_ok then
	return
end

local actions_status_ok, actions = pcall(require, "telescope.actions")
if not actions_status_ok then
	return
end

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous, -- Move to prev result
				["<C-j>"] = actions.move_selection_next, -- Move to next result
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- Send selected to quickfixlist
			},
		},
	},
})

-- Enable telescope fzf native, if installed
pcall(telescope.load_extension, "fzf")
