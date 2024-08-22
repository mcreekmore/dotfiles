# set scoop env path
[environment]::setEnvironmentVariable('SCOOP','C:\scoop','User')

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
    "chrome-remote-desktop-host"
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
    "obsidian"
    "parsec"
    "playnite"
    "plex"
    "plexamp"
    "runelite"
    "slack"
    "soundswitch"
    "spotify"
    "signal"
    "steam"
    "sudo"
    "tailscale"
    "teamviewer"
    "ubisoft-connect"
    "telegram"
    "vscode"
    "wezterm"
    "windirstat"
    "zoom"
)

choco install -y $choco_packages
