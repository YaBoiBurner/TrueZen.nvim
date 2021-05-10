local cmd = vim.cmd

-- bottom specific options

function native_focus_true() -- show
	cmd("vert resize | resize")
	cmd("normal! ze")
end

function native_focus_false() -- don't show
	cmd("wincmd =")
	cmd("normal! ze")
end

function experimental_focus_true()
	cmd("tabe %")
end

function experimental_focus_false()
	cmd("q")
end

return {
	native_focus_true = native_focus_true,
	native_focus_false = native_focus_false,
	experimental_focus_true = experimental_focus_true,
	experimental_focus_false = experimental_focus_false,
}
