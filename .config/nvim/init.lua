vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")
require("misc")
require("plugins.lazy")

require("lazy").setup({
	require("plugins.comment"),
	require("plugins.conform"),
	require("plugins.diffview"),
	require("plugins.gitsigns"),
	require("plugins.harpoon"),
	require("plugins.lazygit"),
	require("plugins.markdown-preview"),
	require("plugins.mini"),
	require("plugins.nvim-cmp"),
	require("plugins.nvim-dap"),
	require("plugins.nvim-dap-ui"),
	require("plugins.nvim-dap-vscode-js"),
	require("plugins.nvim-lspconfig"),
	require("plugins.nvim-tree"),
	require("plugins.nvim-treesitter"),
	require("plugins.nvim-treesitter-textobjects"),
	require("plugins.oil"),
	require("plugins.render-markdown"),
	require("plugins.telescope"),
	require("plugins.todo-comments"),
	require("plugins.undotree"),
	require("plugins.vim-fugitive"),
	require("plugins.vim-sleuth"),
	require("plugins.vim-tmux-navigator"),
	require("plugins.which-key"),

	-- themes
	-- require("themes.tokyonight"),
	require("themes.catppuccin"),
	-- require("themes.primeppuccin"),
	-- require("themes.rose-pine"),
	-- require("themes.kanagawa"),
}, {
	ui = {
		icons = {},
	},
})
