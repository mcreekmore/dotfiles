return { -- Adds git related signs to the gutter, as well as utilities for managing changes
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
	},

	vim.keymap.set("n", "<leader>gh", ":Gitsigns preview_hunk<CR>", {}),
	vim.keymap.set("n", "<leader>gi", ":Gitsigns preview_hunk_inline<CR>", {}),
}
