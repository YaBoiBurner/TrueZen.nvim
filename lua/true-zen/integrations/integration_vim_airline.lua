local M = {}

function M.enable_element()
	vim.cmd("AirlineToggle")
end

function M.disable_element()
	vim.cmd("AirlineToggle")
	vim.cmd("silent! AirlineRefresh")
	vim.cmd("silent! AirlineRefresh")
end

return M
