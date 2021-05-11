local M = {}

function M.enable_element()
	vim.cmd("Limelight")
end

function M.disable_element()
	vim.cmd("Limelight!")
end

return M
