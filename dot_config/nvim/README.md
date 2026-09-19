# nvim

Plugins use native `vim.pack` (0.12+). One file per plugin in `lua/plugins/`, required from `lua/plugins/init.lua`.

## Update

| What | Command |
|---|---|
| Plugins | `:lua vim.pack.update()` → review → `:w` to apply (`:q` to cancel) |
| Save lockfile to chezmoi | `chezmoi re-add ~/.config/nvim/nvim-pack-lock.json` |
| Mason tools (also auto on startup) | `:MasonToolsUpdate` · UI: `:Mason` |
| Treesitter parsers | `:TSUpdate` |

## Remove a plugin

Delete its file + `require` line, restart, then `:lua vim.pack.del({ "name" })`.

## Debug

`:checkhealth` · `:checkhealth vim.lsp` · `:lsp`
