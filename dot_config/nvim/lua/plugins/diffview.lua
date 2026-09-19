-- Git diff/merge views.
vim.pack.add({
	{ src = "https://github.com/sindrets/diffview.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
})

require("diffview").setup({})
