-- [[ LSP ]] Native config (0.11+): vim.lsp.config / vim.lsp.enable.
-- nvim-lspconfig is kept only for the default server definitions it ships under
-- `lsp/`; mason installs the servers, mason-lspconfig enables the installed ones.
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

-- Diagnostics UI
vim.diagnostic.config({
	severity_sort = true,
	float = { source = "if_many" },
	underline = true,
	virtual_text = { source = "if_many", spacing = 2 },
})

-- Broadcast blink.cmp's extra completion capabilities to every server.
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Per-server overrides (merged on top of nvim-lspconfig's defaults).
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" },
		},
	},
})

-- Buffer-local keymaps when a server attaches. Neovim provides the defaults
-- (K hover, grn rename, gra code action, grx codelens, <C-s> signature help);
-- below, the list-style ones (grr/gri/grt/gO) are swapped for Telescope pickers.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local builtin = require("telescope.builtin")
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		map("grr", builtin.lsp_references, "[R]eferences")
		map("gri", builtin.lsp_implementations, "[I]mplementation")
		map("grt", builtin.lsp_type_definitions, "[T]ype definition")
		map("gO", builtin.lsp_document_symbols, "D[O]cument symbols")
		map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- Highlight references of the word under the cursor while it rests there.
		if client and client:supports_method("textDocument/documentHighlight") then
			local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = hl_group,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = hl_group,
				callback = vim.lsp.buf.clear_references,
			})
		end

		-- Toggle inlay hints if the server supports them.
		if client and client:supports_method("textDocument/inlayHint") then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

-- Install & enable servers/tools via mason. mason-tool-installer owns the full
-- list (it accepts lspconfig names) and, unlike mason-lspconfig, keeps them
-- updated: auto_update checks for new versions in the background on startup.
require("mason").setup()
require("mason-lspconfig").setup({
	-- Calls vim.lsp.enable for each installed server. stylua ships an LSP mode,
	-- but conform already formats with it, so don't also run it as a server.
	automatic_enable = { exclude = { "stylua" } },
})
require("mason-tool-installer").setup({
	ensure_installed = {
		-- LSP servers
		"astro",
		"clangd",
		"cssls",
		"denols",
		"gopls",
		"html",
		"lua_ls",
		"marksman",
		"rust_analyzer",
		"ts_ls",
		-- Formatters / debuggers
		"prettier",
		"shfmt",
		"stylua",
		"js-debug-adapter",
	},
	auto_update = true,
})
