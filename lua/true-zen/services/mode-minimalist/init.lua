local M = {}

local minimalist_show

local services = require("true-zen.services")

local service = require("true-zen.services.mode-minimalist.service")
local true_zen = require("true-zen")

-- show and hide minimalist funcs
local function minimalist_true() -- show everything
	if true_zen.get_config().events.before_minimalist_mode_shown then
		true_zen.before_minimalist_mode_shown()
	end

	minimalist_show = true
	service.minimalist_true()

	if true_zen.get_config().events.after_minimalist_mode_shown then
		true_zen.after_minimalist_mode_shown()
	end
end

local function minimalist_false() -- hide everything
	if true_zen.get_config().events.before_minimalist_mode_hidden then
		true_zen.before_minimalist_mode_hidden()
	end

	minimalist_show = false
	service.minimalist_false()

	if true_zen.get_config().events.after_minimalist_mode_hidden then
		true_zen.after_minimalist_mode_hidden()
	end
end

local function toggle()
	if minimalist_show ~= nil then
		return (minimalist_show and minimalist_false or minimalist_true)()
	end
	-- guess by context

	-- note: this is a special case because (nil == (nil and *)) ends up returning true
	-- no idea why
	if services.left.left_show == nil and services.bottom.bottom_show == nil and services.top.top_show == nil then
		minimalist_show = false
		return minimalist_true()
	end
	if services.left.left_show == (services.bottom.bottom_show and services.top.top_show) then
		minimalist_show = services.left.left_show
		return minimalist_false()
	end
	if not (vim.o.showtabline > 0 and (vim.wo.number or vim.wo.relativenumber)) then
		minimalist_show = false
		return minimalist_true()
	end
	minimalist_show = true
	return minimalist_false()
end

local opt_compat = {
	[0] = "toggle",
	[1] = "enable",
	[2] = "disable",
}

local actions = {
	toggle = toggle,
	enable = minimalist_true,
	disable = minimalist_true,
}

function M.main(option)
	option = option or "toggle"
	if type(option) == "number" then
		option = opt_compat[option]
	end
	actions[option]()
end

return M
