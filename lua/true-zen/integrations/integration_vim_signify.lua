local M = {}

function M.enable_element()
	vim.cmd("SignifyToggle")
end

function M.disable_element()
	vim.cmd("SignifyToggle")
end

return M
