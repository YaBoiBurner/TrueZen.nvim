local M = {}

local TZ = require("true-zen")
local cmd_settings = require("true-zen.utils.cmd_settings")

-- left specific options
-- set number
-- set relativenumber
-- set signcolumn=no

-- show
function M.left_true()
	cmd_settings.map_settings(TZ.get_config().left, true, "LEFT")
end

-- hide
function M.left_false()
	cmd_settings.map_settings(TZ.get_config().left, false, "LEFT")
end

return M
