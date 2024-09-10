return {
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {},
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
	config = function()
		require("render-markdown").setup({
			code = {
				-- Determines where language icon is rendered:
				--  right: right side of code block
				--  left:  left side of code block
				position = "left",
				style = "full",
			},
		})
	end,
}
