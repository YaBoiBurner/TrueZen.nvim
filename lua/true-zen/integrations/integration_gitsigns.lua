local M = {}

function M.toggle_element(element)
	if element == 0 then -- current line blame
		vim.cmd("Gitsigns toggle_current_line_blame")
	elseif element == 1 then -- numhl
		vim.cmd("Gitsigns toggle_numhl")
	elseif element == 2 then -- linehl
		vim.cmd("Gitsigns toggle_linehl")
	elseif element == 3 then -- signs
		vim.cmd("Gitsigns toggle_signs")
	end
end

return M
