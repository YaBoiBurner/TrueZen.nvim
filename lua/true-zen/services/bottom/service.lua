local M = {}

local TZ = require("true-zen")

local cmd_settings = require("true-zen.utils.cmd_settings")

-- local cmd = vim.cmd

-- bottom specific options
-- set noshowmode
-- set noruler
-- set laststatus=0
-- set noshowcmd
-- set cmdheight=1

-- show
function M.bottom_true()
	cmd_settings.map_settings(TZ.get_config().bottom, true, "BOTTOM")
end

-- don't show
function M.bottom_false()
	cmd_settings.map_settings(TZ.get_config().bottom, false, "BOTTOM")
end

return M
