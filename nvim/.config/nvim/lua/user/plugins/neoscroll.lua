local status_ok, neoscroll = pcall(require, "neoscroll")
if not status_ok then
	return
end

neoscroll.setup({
	stop_eof = false,
	respect_scrolloff = true,
})
