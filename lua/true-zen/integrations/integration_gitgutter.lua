local M = {}

function M.enable_element()
	vim.cmd("silent! GitGutterEnable")
end

function M.disable_element()
	vim.cmd("silent! GitGutterDisable")
end

return M
