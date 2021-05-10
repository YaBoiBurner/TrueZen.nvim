local M = {}

---@type table<string, string[]>
local hi_groups
local hi_groups_stored
local terms = {
	"cterm",
	"ctermbg",
	"ctermfg",
	"guibg",
	"guifg",
	"gui",
}

local cmd = vim.cmd

function M.set_hi_groups(custome_bg)
	custome_bg = custome_bg or ""

	vim.api.nvim_exec(
		[[
		function! GetColor(group, attr)
			return synIDattr(synIDtrans(hlID(a:group)), a:attr)
		endfunction
		com! -nargs=+ -complete=command GetColor call GetColor(<q-args>)

	]],
		false
	)

	vim.api.nvim_exec(
		[[
		function! SetColor(group, attr, color)
			let gui = has('gui_running') || has('termguicolors') && &termguicolors
			execute printf('hi %s %s%s=%s', a:group, gui ? 'gui' : 'cterm', a:attr, a:color)
		endfunction
		com! -nargs=+ -complete=command SetColor call SetColor(<q-args>)
	]],
		false
	)

	vim.api.nvim_exec(
		[[
		function! Tranquilize(bg_color)
			let bg = GetColor('Normal', 'bg#')
			for grp in ['NonText', 'FoldColumn', 'ColorColumn', 'VertSplit', 'StatusLine', 'StatusLineNC', 'SignColumn']
				" -1 on Vim / '' on GVim
				if bg == -1 || empty(bg)
					call SetColor(grp, 'fg', a:bg_color)
					call SetColor(grp, 'bg', 'NONE')
				else
					call SetColor(grp, 'fg', bg)
					call SetColor(grp, 'bg', bg)
				endif

				call SetColor(grp, '', 'NONE')
			endfor
		endfunction
	]],
		false
	)

	local call_tran = ""

	if custome_bg == "" or custome_bg == nil then
		call_tran = "call Tranquilize('black')"
	else
		call_tran = "call Tranquilize('" .. custome_bg .. "')"
	end

	cmd(call_tran)
end

function M.store_hi_groups()
	hi_groups = {
		NonText = {},
		FoldColumn = {},
		ColorColumn = {},
		VertSplit = {},
		StatusLine = {},
		StatusLineNC = {},
		SignColumn = {},
	}

	for hi_index, _ in pairs(hi_groups) do
		for _, term in ipairs(terms) do
			local term_val = vim.fn.matchstr(vim.fn.execute("hi " .. hi_index), term .. [[=\zs\S*]])

			if term_val == "" then
				term_val = "NONE"
			end

			table.insert(hi_groups[hi_index], term_val)
		end
	end

	hi_groups_stored = true
end

function M.restore_hi_groups()
	if hi_groups_stored then
		for hi_index, _ in pairs(hi_groups) do
			local final_cmd = "highlight " .. hi_index
			local list_of_terms = ""
			for inner_hi_index, _ in pairs(hi_groups[hi_index]) do
				-- we need to construct the cmd like so:

				local current_term = terms[inner_hi_index]
				list_of_terms = string.format(
					"%s %s=%s",
					list_of_terms,
					current_term,
					tostring(hi_groups[hi_index][inner_hi_index])
				)
			end

			final_cmd = final_cmd .. list_of_terms
			vim.cmd(final_cmd)
		end
	end
end

return M
