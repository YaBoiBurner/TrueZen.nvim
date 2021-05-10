local M = {}

-- bottom specific options

function M.native_focus_true() -- show
	vim.cmd("vert resize | resize")
	vim.api.nvim_feedkeys("ze", "n", true)
end

function M.native_focus_false() -- don't show
	vim.cmd("wincmd =")
	vim.api.nvim_feedkeys("ze", "n", true)
end

function M.experimental_focus_true()
	vim.cmd("tabe %")
end

function M.experimental_focus_false()
	vim.cmd("q")
end

return M
