local M = {}

M.bottom_show = vim.o.laststatus > 0

local service = require("true-zen.services.bottom.service")

-- show and hide bottom funcs
local function bottom_true()
	M.bottom_show = true
	service.bottom_true()
end

local function bottom_false()
	M.bottom_show = false
	service.bottom_false()
end

local function toggle()
	M.bottom_show = vim.o.laststatus > 0
	return M.bottom_show and bottom_false() or bottom_true()
end

function M.resume()
	return M.bottom_show and bottom_false() or bottom_true()
end

local opt_compat = {
	[0] = "toggle",
	[1] = "enable",
	[2] = "disable",
}

local actions = {
	toggle = toggle,
	enable = bottom_true,
	disable = bottom_false,
}

function M.main(option)
	option = option or "toggle"
	if type(option) == "number" then
		option = opt_compat[option]
	end
	actions[option]()
end

return M
