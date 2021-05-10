local M = {}

local tz_services = require("true-zen.services")

-- bottom specific options

function M.minimalist_true() -- show
	tz_services.bottom.main("enable")
	tz_services.top.main("enable")
	tz_services.left.main("enable")
end

function M.minimalist_false() -- don't show
	tz_services.bottom.main("disable")
	tz_services.top.main("disable")
	tz_services.left.main("disable")
end

return M
