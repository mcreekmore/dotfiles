-- Source: https://github.com/rose-pine/neovim  (name: rose-pine)
require("rose-pine").setup({
	variant = "auto", -- auto, main, moon, or dawn
	dark_variant = "main",
	styles = {
		bold = true,
		italic = false,
		transparency = false,
	},
})
vim.cmd.colorscheme("rose-pine")
-- Also available: rose-pine-main, rose-pine-moon, rose-pine-dawn
