-- Completion (replaces nvim-cmp + LuaSnip + cmp sources). Docs: https://cmp.saghen.dev
-- Pinned to the v1.x tags so blink fetches a prebuilt binary (no cargo build).
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
})

require("blink.cmp").setup({
	keymap = {
		-- default preset: <C-n>/<C-p> select, <C-y> accept, <C-space> toggle,
		-- <C-e> hide, <C-b>/<C-f> scroll docs. We add <Tab> to accept.
		preset = "default",
		["<Tab>"] = { "accept", "fallback" },
	},

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 200 },
	},

	-- friendly-snippets is picked up automatically by the snippets source.
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "lazydev" },
		providers = {
			-- Make lazydev completions appear before LSP and dedupe.
			lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
		},
	},

	-- Use the Rust fuzzy matcher (downloaded prebuilt with the pinned release).
	fuzzy = { implementation = "prefer_rust_with_warning" },

	signature = { enabled = true },
})
