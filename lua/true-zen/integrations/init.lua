local M, mt = {}, {}

local available_integrations = {
	express_line = true,
	galaxyline = true,
	gitgutter = true,
	gitsigns = true,
	limelight = true,
	lualine = true,
	tmux = true,
	vim_airline = true,
	vim_powerline = true,
	vim_signify = true,
}

function mt:__index(name)
	if available_integrations[name] then
		rawset(self, name, require("true-zen.integrations.integration_" .. name))
		return self[name]
	end
end

M = setmetatable(M, mt)

return M
