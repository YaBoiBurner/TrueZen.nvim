local M = {}

function M.enable_element()
	vim.cmd("doautocmd PowerlineStartup VimEnter")
	vim.cmd("silent! PowerlineReloadColorscheme")
end

function M.disable_element()
	vim.cmd("augroup PowerlineMain")
	vim.cmd("autocmd!")
	vim.cmd("augroup END")
	vim.cmd("augroup! PowerlineMain")
end

return M
