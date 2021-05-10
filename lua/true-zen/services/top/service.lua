local M = {}

local TZ = require("true-zen")
local cmd_settings = require("true-zen.utils.cmd_settings")

-- show
function M.top_true()
	cmd_settings.map_settings(TZ.get_config().top, true, "TOP")
end

-- don't show
function M.top_false()
	cmd_settings.map_settings(TZ.get_config().top, false, "TOP")
end

return M
