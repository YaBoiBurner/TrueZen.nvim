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

local function has(...)
	return vim.fn.has(...) == 1
end

local function GetColor(group, attr)
	return vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
end

local function SetColor(group, attr, color)
	local gui = has("gui_running") or (has("termguicolors") and vim.o.termguicolors)
	vim.cmd(string.format("hi %s %s%s=%s", group, (gui and "gui" or "cterm"), attr, color))
end

local function Tranquilize(bg_color)
	local bg = GetColor("Normal", "bg#")
	for _, grp in ipairs({ "NonText", "FoldColumn", "ColorColumn", "VertSplit", "StatusLine", "StatusLineNC", "SignColumn" }) do
		-- -1 on Vim / '' on GVim
		if bg == -1 or bg == "" then
			SetColor(grp, "fg", bg_color)
			SetColor(grp, "bg", "NONE")
		else
			SetColor(grp, "fg", bg)
			SetColor(grp, "bg", bg)
		end
	end
end

function M.set_hi_groups(custome_bg)
	custome_bg = custome_bg or ""

	if custome_bg == "" or custome_bg == nil then
		Tranquilize("black")
	else
		Tranquilize(custome_bg)
	end
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
