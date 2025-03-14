return {
	"danwlker/primeppuccin",
	priority = 1000,
	dependencies = {
		"catppuccin/nvim",
	},
	init = function()
		vim.cmd.colorscheme("catppuccin")
		vim.cmd.hi("Comment gui=none")
	end,
}
