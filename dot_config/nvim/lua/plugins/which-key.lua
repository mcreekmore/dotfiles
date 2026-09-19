-- Popup showing pending keybinds and documenting leader groups.
vim.pack.add({ { src = "https://github.com/folke/which-key.nvim" } })

require("which-key").setup()

require("which-key").add({
	{ "<leader>g", group = "[G]it" },
	{ "<leader>s", group = "[S]earch" },
	{ "<leader>t", group = "[T]oggle" },
	{ "<leader>w", group = "[W]orkspace" },
	{ "gr", group = "LSP" },
})
