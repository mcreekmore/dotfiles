-- Treesitter (main branch). Highlighting/indent/folds are native (vim.treesitter);
-- this plugin just installs & updates parsers. See :h nvim-treesitter.
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

local ensure_installed = {
	"bash",
	"c",
	"css",
	"go",
	"html",
	"javascript",
	"json",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"python",
	"rust",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
}

-- Installs any missing parsers (no-op for already-installed ones).
require("nvim-treesitter").install(ensure_installed)

-- Start highlighting per buffer for filetypes that have a parser available.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
	callback = function(event)
		local ok = pcall(vim.treesitter.start)
		if ok then
			-- Treesitter-based indentation (experimental on main branch).
			vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
