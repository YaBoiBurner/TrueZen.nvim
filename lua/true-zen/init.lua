local opts = require("true-zen.config").options

local function setup_commands()
	-- top, left
	if opts.true_false_commands then
		vim.api.nvim_exec(
			[[
                " UI components
                command! TZTopT lua require'true-zen.main'.main(1, 1)
                command! TZTopF lua require'true-zen.main'.main(1, 2)
                command! TZLeftT lua require'true-zen.main'.main(2, 1)
                command! TZLeftF lua require'true-zen.main'.main(2, 2)
                command! TZBottomT lua require'true-zen.main'.main(0, 1)
                command! TZBottomF lua require'true-zen.main'.main(0, 2)

                " Modes
                command! TZMinimalistT lua require'true-zen.main'.main(3, 1)
                command! TZMinimalistF lua require'true-zen.main'.main(3, 2)
                command! TZAtaraxisT lua require'true-zen.main'.main(4, 1)
                command! TZAtaraxisF lua require'true-zen.main'.main(4, 2)
                command! TZFocusT lua require'true-zen.main'.main(5, 1)
                command! TZFocusF lua require'true-zen.main'.main(5, 2)
            ]],
			false
		)
	end
end

local function setup_cursor()
	if opts.cursor_by_mode then
		vim.o.guicursor = "i-c-ci:ver25,o-v-ve:hor20,cr-sm-n-r:block"
	end
end

function before_minimalist_mode_shown()
end

function before_minimalist_mode_hidden()
end

function after_minimalist_mode_shown()
end

function after_minimalist_mode_hidden()
end

local function setup(custom_opts)
	require("true-zen.config").set_options(custom_opts)
	opts = require("true-zen.config").options
	setup_commands()
	setup_cursor()
end

return {
	setup = setup,
	before_minimalist_mode_shown = before_minimalist_mode_shown,
	before_minimalist_mode_hidden = before_minimalist_mode_hidden,
	after_minimalist_mode_shown = after_minimalist_mode_shown,
	after_minimalist_mode_hidden = after_minimalist_mode_hidden,
}
