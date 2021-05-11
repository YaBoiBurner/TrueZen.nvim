local M = {}

local opts = require("true-zen").get_config()
local integrations = require("true-zen.integrations")
local mode_minimalist = require("true-zen.services.mode-minimalist")
local before_after_cmds = require("true-zen.utils.before_after_cmd")

local hi_group = require("true-zen.services.mode-ataraxis.modules.hi_group")
local fillchar = require("true-zen.services.mode-ataraxis.modules.fillchar")

local cmd = vim.cmd

vim.api.nvim_exec(
	[[
	" Like bufdo but restore the current buffer.
	function! BufDo(command)
		let currBuff=bufnr("%")
		execute 'bufdo ' . a:command
		execute 'buffer ' . currBuff
	endfunction
	com! -nargs=+ -complete=command Bufdo call BufDo(<q-args>)

	" escape backward slash
	" mental note: don't use simple quotation marks
	" call BufDo("set fillchars+=vert:\\ ")

	" since the function is global, it can be called outside of this nvim_exec statement like so:
	" vim.cmd([[call BufDo("set fillchars+=vert:\\ "
	" don't forget to complete the statement, is just becuase I can't do that within nvim_exec statement
]],
	false
)

function load_integrations(state)
	state = state or false

	if state then
		for opt, _ in pairs(opts.integrations) do
			if opts.integrations[opt] then
				if opt == "integration_galaxyline" then
					integrations.galaxyline.enable_element()
					has_statusline_with_integration = true
				elseif opt == "integration_gitgutter" then
					local is_gitgutter_running = vim.api.nvim_eval("get(g:, 'gitgutter_enabled', 0)")

					if is_gitgutter_running == 0 then -- is not running
						integrations.gitgutter.enable_element()
					end
				elseif opt == "integration_vim_signify" then
					local is_vim_signify_running = vim.api.nvim_eval("empty(getbufvar(bufnr(''), 'sy'))")

					if is_vim_signify_running == 0 then -- is not running
						integrations.vim_signify.enable_element()
					end
				elseif opt == "integration_tmux" then
					local is_tmux_running = vim.env.TMUX

					if is_tmux_running then -- is running
						integrations.tmux.enable_element()
					end
				elseif opt == "integration_vim_airline" then
					local is_vim_airline_running = vim.fn.exists("#airline")

					if is_vim_airline_running == 0 then -- is not running
						integrations.vim_airline.enable_element()
					end

					has_statusline_with_integration = true
				elseif opt == "integration_vim_powerline" then
					local is_vim_powerline_running = vim.fn.exists("#PowerlineMain")

					if is_vim_powerline_running == 0 then -- is not running
						integrations.vim_powerline.enable_element()
					end

					has_statusline_with_integration = true
				elseif opt == "integration_express_line" then
					integrations.express_line.enable_element()

					has_statusline_with_integration = true
				elseif opt == "integration_limelight" then
					integrations.limelight.disable_element()

					has_statusline_with_integration = true
				elseif opt == "integration_gitsigns" then
					local gs_integration = integrations.gitsigns
					local gs_config = require("gitsigns")._get_config()

					if gs_ps_current_line_blame == nil then
						gs_integration.toggle_element(0)
					end

					if gs_ps_numhl == nil then
						gs_integration.toggle_element(1)
					end

					if gs_ps_linehl == nil then
						gs_integration.toggle_element(2)
					end

					if gs_ps_signs == nil then
						gs_integration.toggle_element(3)
					end
				end
			end
		end
	else
		for opt, _ in pairs(opts.integrations) do
			if opts.integrations[opt] then
				if opt == "integration_galaxyline" then
					integrations.galaxyline.disable_element()

					has_statusline_with_integration = true
				elseif opt == "integration_gitgutter" then
					local is_gitgutter_running = vim.api.nvim_eval("get(g:, 'gitgutter_enabled', 0)")

					if is_gitgutter_running == 1 then -- is running
						integrations.gitgutter.disable_element()
					end
				elseif opt == "integration_vim_signify" then
					local is_vim_signify_running = vim.api.nvim_eval("empty(getbufvar(bufnr(''), 'sy'))")

					if is_vim_signify_running == 1 then -- is running
						integrations.vim_signify.disable_element()
					end
				elseif opt == "integration_tmux" then
					local is_tmux_running = vim.env.TMUX

					if is_tmux_running then
						integrations.tmux.disable_element()
					end
				elseif opt == "integration_vim_airline" then
					local is_vim_airline_running = vim.fnexists("#airline")

					if is_vim_airline_running == 1 then -- is running
						integrations.vim_airline.disable_element()
					end

					has_statusline_with_integration = true
				elseif opt == "integration_vim_powerline" then
					local is_vim_powerline_running = vim.fn.exists("#PowerlineMain")

					if is_vim_powerline_running == 1 then -- is running
						integrations.vim_powerline.disable_element()
					end

					has_statusline_with_integration = true
				elseif opt == "integration_express_line" then
					integrations.express_line.disable_element()

					has_statusline_with_integration = true
				elseif opt == "integration_limelight" then
					integrations.limelight.enable_element()

					has_statusline_with_integration = true
				elseif opt == "integration_gitsigns" then
					local gs_integration = integrations.gitsigns
					local gs_config = require("gitsigns")._get_config()

					gs_ps_current_line_blame = nil
					gs_ps_numhl = nil
					gs_ps_linehl = nil
					gs_ps_signs = nil

					if gs_config.current_line_blame == true then
						gs_integration.toggle_element(0)
					else
						gs_ps_current_line_blame = false
					end

					if gs_config.numhl == true then
						gs_integration.toggle_element(1)
					else
						gs_ps_numhl = false
					end

					if gs_config.linehl == true then
						gs_integration.toggle_element(2)
					else
						gs_ps_linehl = false
					end

					if gs_config.signs == true then
						gs_integration.toggle_element(3)
					else
						gs_ps_signs = false
					end
				end
			end
		end
	end
end

function M.ataraxis_true() -- show
	local ataraxis_was_quitted = ""

	if opts.ataraxis.quit_untoggles_ataraxis then
		vim.api.nvim_exec([[
			augroup exit_ataraxis_too
				autocmd!
			augroup END
		]], false)

		ataraxis_was_quitted = vim.g.ataraxis_was_quitted or "NONE"
	end

	if ataraxis_was_quitted == "true" then
		vim.g.ataraxis_was_quitted = nil
	else
		cmd("wincmd h")
		cmd("q")
		cmd("wincmd l")
		cmd("q")

		if opts.ataraxis.top_padding > 0 or tz_top_padding ~= "NONE" and tonumber(tz_top_padding) > 0 then
			cmd("wincmd k")
			cmd("q")

			if top_use_passed_params then
				vim.g.tz_top_padding = nil
				top_use_passed_params = false
			end
		end

		if opts.ataraxis.bottom_padding > 0 or tz_bottom_padding ~= "NONE" and tonumber(tz_bottom_padding) > 0 then
			cmd("wincmd j")
			cmd("q")

			if bottom_use_passed_params then
				vim.g.tz_bottom_padding = nil
				bottom_use_passed_params = false
			end
		end
	end

	------- general
	vim.o.fillchars = ""

	-- if removed, it's likely that numberline and bottom will be removed
	cmd([[call BufDo("lua require'true-zen.services.left'.main(1)")]])
	------ general

	--------------------------=== Splits stuff ===--------------------------
	-- return splitbelow and splitright to user settings:
	if not is_splitbelow_set then
		vim.o.splitbelow = false
	end

	if not is_splitright_set then
		vim.o.splitright = false
	end
	--------------------------=== Splits stuff ===--------------------------

	--------------------------=== Fill chars ===--------------------------

	if not opts.ataraxis.disable_fillchars_configuration then
		fillchar.restore_fillchars()
	end

	--------------------------=== Fill chars ===--------------------------

	--------------------------=== Hi Groups ===--------------------------

	if not opts.ataraxis.disable_bg_configuration then
		hi_group.restore_hi_groups()
	end

	--------------------------=== Hi Groups ===--------------------------

	if not has_statusline_with_integration then
		vim.wo.statusline = current_statusline
	end

	-------------------------=== Integrations ===------------------------
	vim.api.nvim_exec([[
		augroup false_integrations
			autocmd!
		augroup END
	]], false)

	load_integrations(true)

	vim.api.nvim_exec(
		[[
		augroup true_integrations
			autocmd!
			autocmd BufWinEnter * if &modifiable | execute "lua load_integrations(true)" | endif
		augroup END
	]],
		false
	)
	-------------------------=== Integrations ===------------------------

	mode_minimalist.main(1)
end

function M.ataraxis_false() -- hide
	local amount_wins = #vim.api.nvim_list_wins()

	if amount_wins > 1 then
		if opts.ataraxis.force_when_plus_one_window then
			cmd("only")
		else
			print("TrueZen: TZAtaraxis can not be toggled if there is more than one window open. However, you can force it with the force_when_plus_one_window setting")
			return
		end
	end

	if opts.ataraxis.quit_untoggles_ataraxis then
		vim.api.nvim_exec(
			[[
			augroup exit_ataraxis_too
				autocmd!
				autocmd QuitPre * only | let g:the_id = win_getid() | tabe % | call win_gotoid(g:the_id) | close | let g:ataraxis_was_quitted = "true" | execute "lua require('true-zen.services.mode-ataraxis').main(0)"
			augroup END
		]],
			false
		)
	end

	-- autocmd QuitPre * only | let g:the_id = win_getid() | tabe % | call win_gotoid(g:the_id) | close | let g:ataraxis_was_quitted = "true" | execute "lua ataraxis_true()"

	---------------- solves: Vim(Buffer): E86: Buffer 3 does not exist
	is_splitbelow_set = vim.o.splitbelow
	is_splitright_set = vim.o.splitright

	if not is_splitbelow_set or not is_splitright_set then
		vim.o.splitbelow = true
		vim.o.splitright = true
	end
	---------------- solves: Vim(Buffer): E86: Buffer 3 does not exist

	if opts.minimalist.store_and_restore_settings then
		local top_has_been_stored = before_after_cmds.get_has_been_stored("TOP")
		local bottom_has_been_stored = before_after_cmds.get_has_been_stored("BOTTOM")
		local left_has_been_stored = before_after_cmds.get_has_been_stored("LEFT")

		if not top_has_been_stored then
			before_after_cmds.store_settings(opts.top, "TOP")
		end

		if not bottom_has_been_stored then
			before_after_cmds.store_settings(opts.bottom, "BOTTOM")
		end

		if not left_has_been_stored then
			before_after_cmds.store_settings(opts.left, "LEFT")
		end
	end

	-------------------------=== Integrations ===------------------------
	vim.api.nvim_exec([[
		augroup true_integrations
			autocmd!
		augroup END
	]], false)

	load_integrations(false)
	-------------------------=== Integrations ===------------------------

	tz_top_padding = vim.g.tz_top_padding or "NONE"
	tz_left_padding = vim.g.tz_left_padding or "NONE"
	tz_right_padding = vim.g.tz_right_padding or "NONE"
	tz_bottom_padding = vim.g.tz_bottom_padding or "NONE"

	local left_padding_cmd = ""
	local right_padding_cmd = ""
	local top_padding_cmd = ""
	local bottom_padding_cmd = ""

	test_ideal_writing_and_just_me = function()
		if opts.ataraxis.ideal_writing_area_width > 0 then
			-- stuff
			local window_width = vim.api.nvim_win_get_width(0)
			local ideal_writing_area_width = opts.ataraxis.ideal_writing_area_width

			if ideal_writing_area_width == window_width then
				print(
					"TrueZen: the ideal_writing_area_width setting cannot have the same size as your current window, it must be smaller than "
						.. window_width
				)
			else
				total_left_right_width = window_width - ideal_writing_area_width

				if total_left_right_width % 2 > 0 then
					total_left_right_width = total_left_right_width + 1
				end

				local calculated_left_padding = total_left_right_width / 2
				local calculated_right_padding = total_left_right_width / 2

				left_padding_cmd = "vertical resize " .. calculated_left_padding .. ""
				right_padding_cmd = "vertical resize " .. calculated_right_padding .. ""
			end
		else
			if opts.ataraxis.just_do_it_for_me then
				-- calculate padding
				local calculated_left_padding = vim.api.nvim_win_get_width(0) / 4
				local calculated_right_padding = vim.api.nvim_win_get_width(0) / 4

				-- set padding
				left_padding_cmd = "vertical resize " .. calculated_left_padding .. ""
				right_padding_cmd = "vertical resize " .. calculated_right_padding .. ""
			else
				-- stuff
				left_padding_cmd = "vertical resize " .. opts.ataraxis.left_padding .. ""
				right_padding_cmd = "vertical resize " .. opts.ataraxis.right_padding .. ""
			end
		end
	end

	if tz_left_padding ~= "NONE" or tz_right_padding ~= "NONE" then -- not equal to NONE
		if not (tz_left_padding == "NONE") then
			left_padding_cmd = "vertical resize " .. tz_left_padding .. ""
			vim.g.tz_left_padding = nil
		else
			left_padding_cmd = "vertical resize " .. opts.ataraxis.left_padding .. ""
		end

		if not (tz_right_padding == "NONE") then
			right_padding_cmd = "vertical resize " .. tz_right_padding .. ""
			vim.g.tz_right_padding = nil
		else
			right_padding_cmd = "vertical resize " .. opts.ataraxis.right_padding .. ""
		end
	else
		test_ideal_writing_and_just_me()
	end

	-------------------- left buffer
	cmd("leftabove vnew")
	cmd(left_padding_cmd)
	cmd("setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn nonumber norelativenumber noruler noshowmode noshowcmd laststatus=0")
	-------------------- left buffer

	-- return to middle buffer
	cmd("wincmd l")

	-------------------- right buffer
	cmd("vnew")
	cmd(right_padding_cmd)
	cmd("setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn nonumber norelativenumber noruler noshowmode noshowcmd laststatus=0")
	-------------------- right buffer

	-- return to middle buffer
	cmd("wincmd h")

	if not (tz_top_padding == "NONE") then
		top_padding_cmd = "resize " .. tz_top_padding .. ""
		cmd("leftabove new")
		cmd(top_padding_cmd)
		cmd("setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn nonumber norelativenumber noruler noshowmode noshowcmd laststatus=0")

		-- return to middle buffer
		cmd("wincmd j")

		top_use_passed_params = true
	else
		if opts.ataraxis.top_padding > 0 then
			top_padding_cmd = "resize " .. opts.ataraxis.top_padding .. ""
			cmd("leftabove new")
			cmd(top_padding_cmd)
			cmd("setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn nonumber norelativenumber noruler noshowmode noshowcmd laststatus=0")

			-- return to middle buffer
			cmd("wincmd j")
		elseif opts.ataraxis.top_padding == 0 then
			-- do nothing
		else
			print("invalid option set for top_padding param for TrueZen.nvim plugin. It can only be a number >= 0")
		end
	end

	if not (tz_bottom_padding == "NONE") then
		bottom_padding_cmd = "resize " .. tz_bottom_padding .. ""
		cmd("rightbelow new")
		cmd(bottom_padding_cmd)
		cmd("setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn nonumber norelativenumber noruler noshowmode noshowcmd laststatus=0")

		-- return to middle buffer
		cmd("wincmd k")
		bottom_use_passed_params = true
	else
		if opts.ataraxis.bottom_padding > 0 then
			bottom_padding_cmd = "resize " .. opts.ataraxis.bottom_padding .. ""
			cmd("rightbelow new")
			cmd(bottom_padding_cmd)
			cmd("setlocal buftype=nofile bufhidden=wipe nomodifiable nobuflisted noswapfile nocursorline nocursorcolumn nonumber norelativenumber noruler noshowmode noshowcmd laststatus=0")

			-- return to middle buffer
			cmd("wincmd k")
		elseif opts.ataraxis.bottom_padding == 0 then
		else
			print("invalid option set for bottom_padding param for TrueZen.nvim plugin. It can only be a number >= 0")
		end
	end

	--------------------------=== Fill chars ===--------------------------

	if not opts.ataraxis.disable_fillchars_configuration then
		fillchar.store_fillchars()
		fillchar.set_fillchars()
	end

	--------------------------=== Fill chars ===--------------------------

	mode_minimalist.main(2)

	-- this, for some reason, breaks Galaxyline
	---------------------------=== Integrations ===------------------------
	--vim.api.nvim_exec([[
	--	augroup true_integrations
	--		autocmd!
	--	augroup END
	--]], false)

	--load_integrations(false)
	---------------------------=== Integrations ===------------------------

	-- remove the border lines on every buffer
	-- cmd([[call BufDo("set fillchars+=vert:\\ ")]])

	-- hide whatever the user set to be hidden on the left hand side of vim
	cmd([[call BufDo("lua require'true-zen.services.left'.main(2)")]])

	--------------------------=== Hi Groups ===--------------------------

	if not opts.ataraxis.disable_bg_configuration then
		hi_group.store_hi_groups()
		hi_group.set_hi_groups(opts.ataraxis.custome_bg)
	end

	--------------------------=== Hi Groups ===--------------------------

	-- statusline stuff
	if has_statusline_with_integration then
		if opts.ataraxis.force_hide_statusline then
			vim.wo.statusline = "-"
		end
	else
		-- Note: wo.statusline fails here for some reason
		current_statusline = vim.o.statusline
		vim.wo.statusline = "-"
	end

	-------------------------=== Integrations ===------------------------
	vim.api.nvim_exec(
		[[
		augroup false_integrations
			autocmd!
			autocmd BufWinEnter * if &modifiable | execute "lua load_integrations(false)" | endif
		augroup END
	]],
		false
	)
	-------------------------=== Integrations ===------------------------
end

return M
