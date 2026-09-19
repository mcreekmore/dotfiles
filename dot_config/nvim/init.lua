-- Neovim config (0.12+) — native vim.pack, native LSP, blink.cmp.
-- Structure:
--   lua/config/*  core editor settings (options, keymaps, autocmds)
--   lua/plugins/  init.lua auto-loads every other file here; each file is one
--                 self-contained plugin spec (src/version/deps/build/setup)
--   lua/themes/*  colorscheme modules (required by the active plugins/theme.lua)

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("plugins") -- discovers, installs, and configures every plugin file
