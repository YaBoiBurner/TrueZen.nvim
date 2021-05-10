-- bottom specific options

local function native_focus_true() -- show
	vim.cmd("vert resize | resize")
	vim.cmd("normal! ze")
end

local function native_focus_false() -- don't show
	vim.cmd("wincmd =")
	vim.cmd("normal! ze")
end

local function experimental_focus_true()
	vim.cmd("tabe %")
end

local function experimental_focus_false()
	vim.cmd("q")
end

return {
	native_focus_true = native_focus_true,
	native_focus_false = native_focus_false,
	experimental_focus_true = experimental_focus_true,
	experimental_focus_false = experimental_focus_false,
}
