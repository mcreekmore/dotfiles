# dotfiles

configuration managed by [chezmoi](https://www.chezmoi.io/)

## Usage

### Windows
```powershell
irm https://creekmore.io/win | iex
```

### Linux / OSX
```bash
chezmoi init --apply --verbose https://github.com/mcreekmore/dotfiles.git
cd ~/scripts
./<setup>.sh
```