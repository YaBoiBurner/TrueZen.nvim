local M = {}

local final_fillchars, fillchars_stored

function M.set_fillchars()
	vim.cmd([[set fillchars+=stl:\ ]])
	vim.cmd([[set fillchars+=stlnc:\ ]])
	vim.cmd([[set fillchars+=vert:\ ]])
	vim.cmd([[set fillchars+=fold:\ ]])
	vim.cmd([[set fillchars+=foldopen:\ ]])
	vim.cmd([[set fillchars+=foldclose:\ ]])
	vim.cmd([[set fillchars+=foldsep:\ ]])
	vim.cmd([[set fillchars+=diff:\ ]])
	vim.cmd([[set fillchars+=msgsep:\ ]])
	vim.cmd([[set fillchars+=eob:\ ]])
end

function M.store_fillchars()
	local fillchars = vim.o.fillchars

	if fillchars == "" or fillchars == " " or fillchars == nil then
		-- vim's default fillchars are fallen back upon by default
		final_fillchars = ""
	else
		local fillchars_escaped_spaces = fillchars:gsub(": ", ":\\ ")
		local fillchars_escaped_thicc_pipes = fillchars_escaped_spaces:gsub(":│", [[:\│]])
		local fillchars_escaped_thin_pipes = fillchars_escaped_thicc_pipes:gsub(":|", [[:\|]])
		final_fillchars = fillchars_escaped_thin_pipes
	end

	fillchars_stored = true
end

function M.restore_fillchars()
	if fillchars_stored then
		vim.o.fillchars = final_fillchars
	end
end

return M
