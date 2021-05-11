local M = {}

function M.enable_element()
	vim.cmd("silent !tmux set -g status on")
end

function M.disable_element()
	vim.cmd("silent !tmux set -g status off")
end

return M
