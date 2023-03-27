-- import lspsaga safely
local saga_status_ok, saga = pcall(require, "lspsaga")
if not saga_status_ok then
	return
end

saga.setup({
	-- use enter to open file with definition preview
	definition = {
		edit = "<CR>",
	},
	-- Symbols in winbar
	symbol_in_winbar = {
		separator = "  ",
		respect_root = true,
		color_mode = false,
	},
})
