local M = {}

M.left_show = vim.wo.number > 0 or vim.wo.relativenumber > 0 or vim.wo.signcolumn == "yes"

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

function M.main(option)
	option = option or 0

	if option == 0 then -- toggle left (on/off)
		toggle()
	elseif option == 1 then -- show left
		left_true()
	elseif option == 2 then
		left_false()
	else
		-- not recognized
	end
end

return M
