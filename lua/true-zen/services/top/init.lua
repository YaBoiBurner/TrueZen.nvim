local M = {}

local service = require("true-zen.services.top.service")

M.top_show = vim.o.showtabline > 0

-- show and hide top funcs
local function top_true()
	M.top_show = true
	service.top_true()
end

local function top_false()
	M.top_show = false
	service.top_false()
end

--- If status line is true, then hide. Otherwise, show.
local function toggle()
	M.top_show = vim.o.showtabline > 0
	return M.top_show and top_false() or top_true()
end

function M.resume()
	return M.top_show and top_true() or top_false()
end

local opt_compat = {
	[0] = "toggle",
	[1] = "enable",
	[2] = "disable",
}

local actions = {
	toggle = toggle,
	enable = top_true,
	disable = top_false,
}

function M.main(option)
	option = option or 0
	if type(option) == "number" then
		option = opt_compat[option]
	end
	actions[option]()
end

return M
