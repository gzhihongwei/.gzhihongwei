local comment_status_ok, comment = pcall(require, "Comment")
if not comment_status_ok then
	return
end

local context_comment_utils_status_ok, context_comment_utils = pcall(require, "ts_context_commentstring.utils")
if not context_comment_utils_status_ok then
	return
end

comment.setup({
	pre_hook = function(ctx)
		local U = require("Comment.utils")

		-- Determine whether to use linewise or blockwise commentstring
		local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

		-- Determine the location where to calculate commentstring from
		local location = nil
		if ctx.ctype == U.ctype.blockwise then
			location = context_comment_utils.get_cursor_location()
		elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
			location = context_comment_utils.get_visual_start_location()
		end

		return require("ts_context_commentstring.internal").calculate_commentstring({
			key = type,
			location = location,
		})
	end,
})
