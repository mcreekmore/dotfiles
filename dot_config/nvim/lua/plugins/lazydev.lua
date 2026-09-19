-- Lua LS setup for editing Neovim config (replaces the deprecated neodev.nvim).
vim.pack.add({ { src = "https://github.com/folke/lazydev.nvim" } })

require("lazydev").setup({
	library = {
		-- Load luvit types when the `vim.uv` word is found.
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		-- Types for nvim-dap-ui (previously configured through neodev).
		"nvim-dap-ui",
	},
})
