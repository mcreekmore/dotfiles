return {
	"MeanderingProgrammer/render-markdown.nvim",
	opts = {},
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
	config = function()
		require("render-markdown").setup({
			code = {
				position = "left",
				style = "full",
			},
		})
	end,
}
