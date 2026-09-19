-- Git signs in the gutter + hunk utilities.
vim.pack.add({ { src = "https://github.com/lewis6991/gitsigns.nvim" } })

require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

vim.keymap.set("n", "<leader>gh", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview git [H]unk" })
vim.keymap.set("n", "<leader>gi", "<cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Preview git hunk [I]nline" })
