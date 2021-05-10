local M = {}

M.left_show = vim.wo.number or vim.wo.relativenumber or vim.wo.signcolumn == "yes"

local service = require("true-zen.services.left.service")

-- show and hide left funcs
local function left_true()
	M.left_show = true
	service.left_true()
end

local function left_false()
	M.left_show = false
	service.left_false()
end

local function toggle()
	return M.left_show and left_false() or left_true()
end

function M.resume()
	return M.left_show and left_true() or left_false()
end

local opt_compat = {
	[0] = "toggle",
	[1] = "enable",
	[2] = "disable",
}

local actions = {
	toggle = toggle,
	enable = left_true,
	disable = left_false,
}

function M.main(option)
	option = option or "toggle"
	if type(option) == "number" then
		option = opt_compat[option]
	end
	actions[option]()
end

return M
