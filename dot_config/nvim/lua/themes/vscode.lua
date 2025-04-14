return {
	{
		"Mofiqul/vscode.nvim",
		lazy = false, -- Load the theme immediately
		priority = 1000, -- Ensure it loads early
		config = function()
			-- Optional: configure and enable the theme here
			require("vscode").setup({
				-- You can customize the theme here
				-- transparent = false,
				-- italic_comments = true,
				-- disable_nvimtree_bg = true,
			})
			-- Set the colorscheme
			vim.cmd([[colorscheme vscode]])
		end,
	},
}
