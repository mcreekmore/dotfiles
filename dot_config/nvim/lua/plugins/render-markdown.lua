-- Pretty in-buffer markdown rendering. (Uses treesitter + mini, loaded by their
-- own files.)
vim.pack.add({ { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" } })

require("render-markdown").setup({
	code = {
		position = "left",
		style = "full",
	},
})
