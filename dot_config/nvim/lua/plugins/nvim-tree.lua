-- File tree sidebar.
vim.pack.add({ { src = "https://github.com/nvim-tree/nvim-tree.lua" } })

require("nvim-tree").setup({})
vim.keymap.set("n", "<leader>tt", "<cmd>NvimTreeToggle<CR>", { desc = "[T]oggle File [T]ree" })
