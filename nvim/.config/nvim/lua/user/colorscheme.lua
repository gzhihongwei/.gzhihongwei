local status_ok, github_theme = pcall(require, "github-theme")
if not status_ok then
	return
end

github_theme.setup({
	theme_style = "dark_default",
	function_style = "italic",
	sidebars = { "qf", "vista_kind", "terminal", "packer" },

	-- Change the "hint" color to the "orange" color
	colors = {
		-- hint = "orange",
		syntax = { variable = "#c9d1d9" },
	},
	--
	-- -- Overwrite the highlight groups
	-- overrides = function(c)
	-- 	return {
	-- 		-- htmlTag = { fg = c.red, bg = "#282c34", sp = c.hint, style = "underline" },
	-- 		DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
	-- 		-- this will remove the highlight groups
	-- 		TSField = {},
	-- 	}
	-- end,
})
