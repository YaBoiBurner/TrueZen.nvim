local M = {}

local services = require("true-zen.services")
local service_compat = {
	[0] = "bottom",
	[1] = "top",
	[2] = "left",
	[3] = "mode-minimalist",
	[4] = "mode-ataraxis",
	[5] = "mode-focus",
}

function M.main(service, command_option)
	service = service or "bottom"
	command_option = command_option or 0
	if type(service) == "number" then
		service = service_compat[service]
	end
	return services[service].main(command_option)
end

return M
