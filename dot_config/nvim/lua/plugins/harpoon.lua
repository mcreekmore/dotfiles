-- Quick file marks/navigation (harpoon2).
vim.pack.add({
	{ src = "https://github.com/theprimeagen/harpoon", version = "harpoon2" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
})

local harpoon = require("harpoon")
harpoon:setup({})

-- Telescope picker over the harpoon list.
local function toggle_telescope(harpoon_files)
	local conf = require("telescope.config").values
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers")
		.new({}, {
			prompt_title = "Harpoon",
			finder = require("telescope.finders").new_table({ results = file_paths }),
			previewer = conf.file_previewer({}),
			sorter = conf.generic_sorter({}),
		})
		:find()
end

vim.keymap.set("n", "<C-e>", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window (telescope)" })
vim.keymap.set("n", "<leader>sa", function()
	toggle_telescope(harpoon:list())
end, { desc = "[S]earch H[a]rpoon marks" })

vim.keymap.set("n", "<leader>A", function()
	harpoon:list():add()
end, { desc = "Harpoon add file" })
vim.keymap.set("n", "<leader>a", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon quick menu" })

for i = 1, 5 do
	vim.keymap.set("n", "<leader>" .. i, function()
		harpoon:list():select(i)
	end, { desc = "Harpoon to file " .. i })
end
