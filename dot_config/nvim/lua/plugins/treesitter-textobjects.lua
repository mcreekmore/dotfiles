-- Treesitter textobjects (main branch): setup + explicit keymaps.
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
})

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true, -- jump forward to the textobject, like targets.vim
		selection_modes = {
			["@parameter.outer"] = "v", -- charwise
			["@function.outer"] = "V", -- linewise
			["@class.outer"] = "<c-v>", -- blockwise
		},
		include_surrounding_whitespace = true,
	},
})

local select = require("nvim-treesitter-textobjects.select")
local function map(key, query, desc)
	vim.keymap.set({ "x", "o" }, key, function()
		select.select_textobject(query, "textobjects")
	end, { desc = desc })
end

map("af", "@function.outer", "Select outer function")
map("if", "@function.inner", "Select inner function")
map("ac", "@class.outer", "Select outer class")
map("ic", "@class.inner", "Select inner class")
