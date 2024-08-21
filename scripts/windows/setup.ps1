# set scoop env path
[environment]::setEnvironmentVariable('SCOOP','C:\scoop','User')

# install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# install packages
$choco_packages = @(
    '7zip'
    "audacity"
    "autohotkey"
    "bitwarden"
    "chrome-remote-desktop-host"
    "citrix-workspace"
    "discord"
    "element-desktop"
    "firefox"
    "gimp"
    "googlechrome"
    "googledrive"
    "hwmonitor"
    "keepassxc"
    "mullvad-app"
    "msiafterburner"
    "geforce-experience"
    "obsidian"
    "parsec"
    "playnite"
    "plex"
    "plexamp"
    "slack"
    "soundswitch"
    "spotify"
    "signal"
    "steam"
    "sudo"
    "tailscale"
    "teamviewer"
    "telegram"
    "vscode"
    "wezterm"
    "microsoft-windows-terminal"
    "zoom"
)

choco install -y $choco_packages

# install packages
choco install -y 7zip
choco install -y audacity
choco install -y autohotkey
choco install -y bitwarden
choco install -y chrome-remote-desktop-host
choco install -y citrix-workspace
choco install -y discord
choco install -y element-desktop
choco install -y firefox
choco install -y gimp
choco install -y googlechrome
choco install -y googledrive
choco install -y hwmonitor
choco install -y keepassxc
choco install -y mullvad-app
choco install -y msiafterburner
choco install -y geforce-experience
choco install -y obsidian
choco install -y parsec
choco install -y playnite
choco install -y plex
choco install -y plexamp
choco install -y slack
choco install -y soundswitch
choco install -y spotify
choco install -y signal
choco install -y steam
choco install -y sudo
choco install -y tailscale
choco install -y teamviewer
choco install -y telegram
choco install -y vscode
choco install -y wezterm
choco install -y microsoft-windows-terminal
choco install -y zoom

# install scoop
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "Scoop is already installed. Skipping installation."
} else {
    try {
        iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
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
scoop install nerd-fonts/Hack-NF-Mono
scoop install anderlli0053_DEV-tools/slippi-launcher

# install contexts to registry
# & $env:SCOOP\apps\7zip\current\install-context.reg
