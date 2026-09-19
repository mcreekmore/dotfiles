-- Autoformat.
vim.pack.add({ { src = "https://github.com/stevearc/conform.nvim" } })

require("conform").setup({
	notify_on_error = false,
	format_on_save = function(bufnr)
		-- Disable "format on save + lsp fallback" for languages without a
		-- well-standardized style; add or re-enable as you like.
		local disable_filetypes = { c = true, cpp = true }
		local lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback"
		return {
			timeout_ms = 500,
			lsp_format = lsp_format,
		}
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		-- python = { "isort", "black" },
		-- javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})

vim.keymap.set("", "<leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })
