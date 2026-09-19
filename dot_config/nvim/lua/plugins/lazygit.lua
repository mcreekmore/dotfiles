-- LazyGit integration.
vim.pack.add({
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
})

vim.keymap.set("n", "<leader>gl", "<cmd>LazyGit<cr>", { desc = "[G]it [L]azyGit" })
