
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
scoop bucket add okibcn_ScoopMaster https://github.com/okibcn/ScoopMaster

# install packages using scoop
scoop install 7zip
scoop install audacity
scoop install autohotkey
scoop install bitwarden
scoop install discord
scoop install element
scoop install firefox
scoop install gimp
scoop install googlechrome
scoop install anderlli0053_DEV-tools/googledrive-np --skip-hash-check
scoop install nerd-fonts/Hack-NF-Mono
scoop install hwmonitor
scoop install keepassxc
scoop install nonportable/mullvadvpn-np
scoop install okibcn_ScoopMaster/msi-afterburner
scoop install anderlli0053_DEV-tools/nvidia-geforce-experience-np
scoop install obsidian
scoop install nonportable/parsec-np --skip-hash-check
scoop install playnite
scoop install anderlli0053_DEV-tools/plexamp
scoop install plex-desktop
scoop install slack
scoop install soundswitch
scoop install spotify
scoop install signal
scoop install anderlli0053_DEV-tools/slippi-launcher
scoop install steam
scoop install sudo
scoop install tailscale
scoop install teamviewer
scoop install telegram
scoop install vscode
scoop install wezterm
scoop install whatsapp
scoop install windows-terminal
scoop install zoom

# install contexts to registry
& $env:SCOOP\apps\7zip\current\install-context.reg
