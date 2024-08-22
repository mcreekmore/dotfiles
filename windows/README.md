# Windows Setup

### Configure powershell scripts

```powershell
# in admin powershell
Set-ExecutionPolicy unrestricted
./setup.ps1
```

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

## Manually install

- [Geforce Experience](https://www.nvidia.com/en-us/geforce/geforce-experience/download/)
- [MSI Afterburner](https://www.msi.com/Landing/afterburner/graphics-cards)
- [Mullvad VPN](https://mullvad.net/en/download/vpn/windows)
