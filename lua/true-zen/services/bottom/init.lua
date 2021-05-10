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

function M.main(option)
	option = option or 0

	if option == 0 then -- toggle statuline (on/off)
		toggle()
	elseif option == 1 then -- show status line
		bottom_true()
	elseif option == 2 then
		bottom_false()
	else
		-- not recognized
	end
end

return M
