local M = {}

local services = require("true-zen.services")

local service = require("true-zen.services.mode-minimalist.service")
local true_zen = require("true-zen")

local api = vim.api

-- show and hide minimalist funcs
local function minimalist_true() -- show everything
	if true_zen.get_config().events.before_minimalist_mode_shown then
		true_zen.before_minimalist_mode_shown()
	end

	minimalist_show = 1
	service.minimalist_true()

	if true_zen.get_config().events.after_minimalist_mode_shown then
		true_zen.after_minimalist_mode_shown()
	end
end

local function minimalist_false() -- hide everything
	if true_zen.get_config().events.before_minimalist_mode_hidden then
		true_zen.before_minimalist_mode_hidden()
	end

	minimalist_show = 0
	service.minimalist_false()

	if true_zen.get_config().events.after_minimalist_mode_hidden then
		true_zen.after_minimalist_mode_hidden()
	end
end

-- 1 if being shown
-- 0 if being hidden
local function toggle()
	-- minimalist_show = vim.api.nvim_eval("&laststatus > 0 || &showtabline > 0")
	if minimalist_show == 1 then -- minimalist true, shown; thus, hide
		minimalist_false()
	elseif minimalist_show == 0 then -- minimalist false, hidden; thus, show
		minimalist_true()
	elseif minimalist_show == nil then
		-- guess by context
		if
			(services.left.left_show == nil)
			and (services.bottom.bottom_show == nil)
			and (services.top.top_show == nil)
		then
			minimalist_show = 0
			minimalist_false()
		elseif
			(services.left.left_show == true)
			and (services.bottom.bottom_show == true)
			and (services.top.top_show == true)
		then
			minimalist_show = 1
			minimalist_false()
		elseif
			(services.left.left_show == false)
			and (services.bottom.bottom_show == false)
			and (services.top.top_show == false)
		then
			minimalist_show = 0
			minimalist_true()
		elseif
			(api.nvim_eval("&laststatus > 0 || &showtabline > 0") == 1)
			and (api.nvim_eval("&showtabline > 0") == 1)
			and (api.nvim_eval("&number > 0 || &relativenumber > 0") == 1)
		then
			minimalist_show = 1
			minimalist_false()
		elseif
			(api.nvim_eval("&laststatus > 0 || &showtabline > 0") == 0)
			and (api.nvim_eval("&showtabline > 0") == 0)
			and (api.nvim_eval("&number > 0 || &relativenumber > 0") == 0)
		then
			minimalist_show = 0
			minimalist_true()
		else
			minimalist_show = 1
			minimalist_false()
		end
	else
		minimalist_show = 1
		minimalist_false()
	end
end

function M.main(option)
	option = option or 0

	if option == 0 then -- toggle statuline (on/off)
		toggle()
	elseif option == 1 then -- show status line
		minimalist_true()
	elseif option == 2 then
		minimalist_false()
	end
end

return M
