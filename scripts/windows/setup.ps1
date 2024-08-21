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
    "okibcn_ScoopMaster/googledrive-np_(1)"
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
    "okibcn_ScoopMaster/plexamp_(1)"
    "plex-desktop"
    "slack"
    "soundswitch"
    "spotify"
    "signal"
    "okibcn_ScoopMaster/slippi-launcher_(1)"
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
try { iex "& {$(irm get.scoop.sh)} -RunAsAdmin" }
catch { "Erorr installing scoop. Likely already installed. }

# enable scoop buckets
scoop install git

# enable multi-connection downloads
# scoop install aria2
# scoop config aria2-enabled true

# add scoop buckets
scoop bucket add extras
scoop bucket add okibcn_ScoopMaster https://github.com/okibcn/ScoopMaster
scoop bucket add nerd-fonts
scoop bucket add nonportable
scoop bucket add versions

# install packages using scoop
scoop install $local_packages

# install contexts to registry
& $env:SCOOP\apps\7zip\current\install-context.reg
