local M, mt = {}, {}

local available_services = {
	["bottom"] = true,
	["left"] = true,
	["mode-ataraxis"] = true,
	["mode-focus"] = true,
	["mode-minimalist"] = true,
	["resume"] = true,
	["top"] = true,
}

function mt:__index(mod)
	if available_services[mod] then
		rawset(self, mod, require("true-zen.services." .. mod))
		return self[mod]
	end
end

M = setmetatable(M, mt)

return M
