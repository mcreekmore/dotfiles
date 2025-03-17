# dotfiles

configuration managed by [chezmoi](https://www.chezmoi.io/)

## Usage

### Windows
```powershell
irm https://creekmore.io/win | iex
```

### Linux / OSX
```bash
curl -sSfL https://creekmore.io/setup.sh | sh
# chezmoi init --apply --verbose https://github.com/mcreekmore/dotfiles.git
cd ~/scripts
./<setup>.sh
```