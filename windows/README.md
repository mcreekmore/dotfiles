# Windows Setup

## Setup

```powershell
# in admin powershell
Set-ExecutionPolicy unrestricted
./setup.ps1
```

## Manually install

- [MSI Afterburner](https://www.msi.com/Landing/afterburner/graphics-cards)
- [Jagex Launcher](https://www.runescape.com/launcher)

## wsl

### Export current image

```powershell
wsl --export (distribution) (filename.tar)
```

### Import image

```powershell
wsl --import ubuntu C:\wsl .\ubuntu.tar
wsl --set-default ubuntu
```

To configure default user go into the wsl instance and make the following change

```conf
# in /etc/wsl.conf
[user]
default=matt
```

Then terminate wsl

```powershell
 wsl --terminate ubuntu
```

## Wezterm config

```powershell
git clone https://github.com/mcreekmore/.dotfiles.git C:\Users\matt\.config\wezterm\
cd C:\Users\matt\.config\wezterm\
mklink .\wezterm.lua .config\wezterm\wezterm.lua
```
