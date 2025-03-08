# set scoop env path
[environment]::setEnvironmentVariable('SCOOP', 'C:\scoop', 'User')

# copy powershell profile location
Copy-Item ".\Microsoft.PowerShell_profile.ps1" -Destination "$PROFILE"

# set timezone
%windir%\system32\tzutil /s "Eastern Standard Time"

# install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# install scoop
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "Scoop is already installed. Skipping installation."
} else {
    try {
        Invoke-Expression "& {$(Invoke-RestMethod get.scoop.sh)} -RunAsAdmin"
        Write-Host "Scoop installed successfully."
    } catch {
        Write-Host "Error installing Scoop."
    }
}

# enable scoop buckets
scoop install git

# enable multi-connection downloads
# scoop install aria2
# scoop config aria2-enabled true

# add scoop buckets
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add anderlli0053_DEV-tools https://github.com/anderlli0053/DEV-tools

# install scoop stuff
# scoop install extras/rtss
scoop install nerd-fonts/Hack-NF-Mono
scoop install anderlli0053_DEV-tools/slippi-launcher

# install contexts to registry
# & $env:SCOOP\apps\7zip\current\install-context.reg

# install packages
$choco_packages = @(
    "audacity"
    "autohotkey"
    "bitwarden"
    "brave",
    "chezmoi",
    "chrome-remote-desktop-host"
    "cpu-z",
    "citrix-workspace"
    "directx"
    "discord"
    "docker-desktop"
    "ea-app"
    "element-desktop"
    "firefox"
    "gimp"
    "goggalaxy"
    "googlechrome"
    "googledrive"
    "hwmonitor"
    "keepassxc"
    "malwarebytes"
    "microsoft-windows-terminal"
    "mullvad-app"
    "obs-studio"
    "obsidian"
    "parsec"
    "playnite"
    "plex"
    "plexamp"
    "powertoys"
    "rufus"
    "runelite"
    "signal"
    "slack"
    "soundswitch"
    "spotify"
    "starship"
    "steam"
    "sudo"
    "tailscale"
    "teamviewer"
    "ubisoft-connect"
    "telegram"
    "vlc"
    "vnc-viewer"
    "vortex"
    "vscode"
    "wezterm"
    "winbtrfs"
    "windirstat"
    "zoom"
)

choco install -y $choco_packages

# TODO chezmoi init dotfiles