$local_packages = @(
    "7zip"
    "audacity"
    "autohotkey"
    "bitwarden"
    "discord"
    "element"
    "firefox"
    "gimp"
    "googlechrome"
    "anderlli0053_DEV-tools/googledrive-np"
    "nerd-fonts/Hack-NF-Mono"
    "hwmonitor"
    "keepassxc"
    "microsoft-edge"
    "nonportable/mullvadvpn-np"
    "msiafterburner"
    "okibcn_ScoopMaster/nvidia-geforce-experience-np"
    "obsidian"
    "nonportable/parsec-np"
    "playnite"
    "anderlli0053_DEV-tools/plexamp"
    "plex-desktop"
    "slack"
    "soundswitch"
    "spotify"
    "signal"
    "anderlli0053_DEV-tools/slippi-launcher"
    "steam"
    "sudo"
    "tailscale"
    "teamviewer"
    "telegram"
    "vscode"
    "wezterm"
    "whatsapp"
    "windows-terminal"
    "zoom"
)

# $global_packages = @(
# )

# set scoop env path
[environment]::setEnvironmentVariable('SCOOP','C:\scoop','User')

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
scoop bucket add nonportable
scoop bucket add versions
scoop bucket add anderlli0053_DEV-tools https://github.com/anderlli0053/DEV-tools

# install packages using scoop
scoop install $local_packages

# install contexts to registry
& $env:SCOOP\apps\7zip\current\install-context.reg
