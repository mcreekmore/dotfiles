return {
	-- Useful plugin to show you pending keybinds.
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function() -- This is the function that runs, AFTER loading
		require("which-key").setup()

		-- Document existing key chains
		require("which-key").add({
			-- ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
			-- ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
			-- ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
			-- ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
			-- ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
			-- ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
			-- ["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },
			-- ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
			-- ["<leader>u"] = { name = "[U]ndotree", _ = "which_key_ignore" },
			{ "<leader>c", group = "[C]ode" },
			-- { "<leader>c_", hidden = true },
			{ "<leader>d", group = "[D]ocument" },
			-- { "<leader>d_", hidden = true },
			{ "<leader>g", group = "[G]it" },
			-- { "<leader>g_", hidden = true },
			{ "<leader>h", group = "Git [H]unk" },
			-- { "<leader>h_", hidden = true },
			{ "<leader>r", group = "[R]ename" },
			-- { "<leader>r_", hidden = true },
			{ "<leader>s", group = "[S]earch" },
			-- { "<leader>s_", hidden = true },
			{ "<leader>t", group = "[T]oggle" },
			-- { "<leader>t_", hidden = true },
			{ "<leader>u", group = "[U]ndotree" },
			-- { "<leader>u_", hidden = true },
			{ "<leader>w", group = "[W]orkspace" },
			-- { "<leader>w_", hidden = true },
		})
		-- visual mode
		require("which-key").add({
			"<leader>h",
			desc = "Git [H]unk",
			mode = "v",
		}, { mode = "v" })
	end,
}
