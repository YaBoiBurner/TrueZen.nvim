local service = require("true-zen.services.mode-focus.service")
local opts = require("true-zen").get_config()

-- show and hide focus funcs
local function focus_true() -- focus window
	local focus_method = opts.focus.focus_method:lower()
	local amount_wins = #vim.api.nvim_list_wins()

	if focus_method == "native" then
		if amount_wins == 1 then
			print("You can not focus this window because focusing a window only works when there are more than one.")
			focus_show = 0
		elseif amount_wins > 1 then
			focus_show = 1
			service.native_focus_true()
		end
	elseif focus_method == "experimental" then
		focus_show = 1
		service.experimental_focus_true()

		if opts.integrations.integration_tzfocus_tzataraxis then
			-- nil if it hasn't been toggled
			ataraxis_is_toggled = require("true-zen.services.mode-ataraxis").ataraxis_show
			if ataraxis_is_toggled == 0 or ataraxis_is_toggled == nil then
				require("true-zen.main").main(4, 2)
				ataraxis_is_toggled = 1
			end
		end
	end
end

local function focus_false() -- unfocus window
	local focus_method = opts.focus.focus_method:lower()
	local amount_wins = #vim.api.nvim_list_wins()

	if focus_method == "native" then
		focus_show = 0

		if amount_wins == 1 then
			vim.cmd("You can not unfocus this window because focusing a window only works when there are more than one.")
		elseif amount_wins > 1 then
			service.native_focus_false()
		end
	elseif focus_method == "experimental" then
		focus_show = 0

		if opts.integrations.integration_tzfocus_tzataraxis then
			-- if it's nil or anything else then it's because it hasn't been executed
			if ataraxis_is_toggled == 1 then
				require("true-zen.main").main(4, 1)
			end
		end

		service.experimental_focus_false()
	end
end

-- 1 = is focused
-- 0 = is not focused
local function toggle()
	if focus_show ~= nil and focus_show == 1 then
		focus_false()
	elseif focus_show ~= nil and focus_show == 0 then
		focus_true()
	elseif focus_show == nil then
		local amount_wins = #vim.api.nvim_list_wins()

		if amount_wins > 1 then
			local focus_method = opts.focus.focus_method:lower()

			if focus_method == "native" then
				local total_current_session = vim.o.lines + vim.o.columns
				local total_current_window = vim.api.nvim_win_get_width(0) + vim.api.nvim_win_get_height(0)

				local difference = total_current_session - total_current_window

				for i = 1, tonumber(opts.focus.margin_of_error), 1 do
					if difference == i then
						-- since difference is small, it's assumable that window is focused
						focus_false()
						break
					elseif i == tonumber(opts.focus.margin_of_error) then
						-- difference is too big, it's assumable that window is not focused
						focus_true()
						break
					end
				end
			elseif focus_method == "experimental" then
				-- orig_win_id = vim.api.nvim_eval("win_getid()")
				focus_true()
			end
		else
			-- since there should always be at least one window
			focus_show = 0
			print("you can not (un)focus this window, because it is the only one!")
		end
	end
end

local function main(option)
	option = option or 0

	if option == 0 then -- toggle focus (on/off)
		toggle()
	elseif option == 1 then -- focus window
		focus_true()
	elseif option == 2 then -- unfocus window
		focus_false()
	end
end

return {
	main = main,
}
