$ErrorActionPreference = "Stop"

$oldRoot = "E:\Users\matt"
$stage   = "$env:TEMP\GameSavesStage"
$destDir = "C:\Backups"
$zip     = "$destDir\GameSaves.zip"
$log     = "$destDir\robocopy-last-run.log"

if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir | Out-Null
}
if (Test-Path $stage) {
    Remove-Item $stage -Recurse -Force
}

# Non-game software found in AppData\Local on the old install. Everything
# else under Local is kept, since most of it is per-game save/config data.
# Folders we couldn't identify were left OUT of this list (kept) on purpose -
# better to carry a little extra junk than silently drop a real save.
$localExclude = @(
    ".Raycast.backups", ".resourcefullib", "22bfc34d90b64054809542014fc9eb32",
    "@joplinapp-desktop-updater", "Ableton", "Abyssus", "Activision", "AMD",
    "AMD Ryzen Master", "AMDIdentifyWindow", "AMDInstallManager",
    "AMDSoftwareInstaller", "AMD_Common", "AnybrainSDK", "appsflyer",
    "archon-updater", "ASP.NET", "AWSToolkit", "babl-0.1", "balena_etcher",
    "BattlEye", "bettercrewlink-updater", "bifrost", "bitwarden-updater",
    "blitz-updater", "bruno-updater", "BraveSoftware", "calibre-cache", "CEF",
    "checkpoint-nodejs", "Chromium", "Citrix", "claude-cli-nodejs",
    "com.add0n.native_client", "com.glzr.zebar", "com.zevnda.steam-game-idler",
    "comgr", "ConnectedDevicesPlatform", "CrashDumps", "CrashReportClient",
    "CrashRpt", "CtxUnleashClient", "curseforge-updater", "D3DSCache", "Dell",
    "Discord", "DiscordPTB", "Docker", "docker-secrets-engine",
    "Downloaded Installations", "Duplicati", "DWriteCore",
    "EAConnect_microsoft", "EACrashReporter", "EADesktop", "EALaunchHelper",
    "element-desktop", "FabPlugins", "fontconfig", "gegl-0.4", "GIMP", "go",
    "go-build", "goimports", "Google", "gopls", "gtk-2.0", "imput",
    "INetHistory", "InputLeap", "io.hoppscotch.desktop", "IsolatedStorage",
    "JetBrains", "k9s", "KeePassXC", "LGHUB", "librewolf", "Logitech",
    "Logitechr Webcam Software", "Malwarebytes", "mattermost-desktop-updater",
    "Mega Limited", "Microsoft", "Microsoft_Corporation", "mkcert", "mod.io",
    "Mozilla", "mpv", "Mullvad", "main.kts.compiled.cache", "NgConsentManager",
    "Nextcloud", "npm-cache", "NVIDIA Corporation", "nvim-data",
    "obsidian-updater", "oh-my-posh", "Ollama", "OneDrive", "org.asyar.app",
    "Overwolf", "Package Cache", "Packages", "PlaceholderTileLogoFolder",
    "Plex", "Plexamp", "plexamp-updater", "podman-desktop-updater", "Postman",
    "Proton", "ProtonPass", "proton_mail", "pnpm", "pnpm-cache",
    "pnpm-state", "pip", "r2modman-updater", "Raycast", "RealVNC", "rustdesk",
    "Sentry", "Setup", "SquirrelTemp", "Steam", "stirling.pdf.dev",
    "Tailscale", "TeamSpeak", "TeamSpeak 3", "TeamViewer",
    "theorycraft-games-launcher-updater", "tlrc",
    "ToastNotificationManagerCompat", "UniCompactView", "VirtualStore",
    "Vivox", "vortex-updater", "Wabbajack", "wago-app-updater",
    "weakauras-companion-updater", "winutil", "wsl", "Yaak",
    "z-library-updater", "zoxide", "Temp", "webviewdata"
)

# Same idea for AppData\Roaming.
$roamingExclude = @(
    ".iris-installer", "Adobe", "AMD", "app.yaak.desktop", "astro",
    "balenaEtcher", "Bitwarden", "Bitwarden CLI", "Blitz", "bruno",
    "com.zevnda.steam-game-idler", "containers", "Cycling '74", "Dell",
    "direnv", "discord", "discordptb", "Docker", "Docker Desktop",
    "EAAntiCheat.Installer.Tool", "EasyAntiCheat", "Electronic Arts",
    "Element", "Ente Technologies, Inc", "fluxer", "Floorp", "fltk.org",
    "fyne", "G HUB", "GIMP", "go", "gopls", "helm", "HexChat", "ICAClient",
    "io.hoppscotch.desktop", "JetBrains", "Joplin", "KeePassXC", "lghub",
    "librewolf", "MAGIX", "Microsoft", "mkbrr-gui.exe", "ModrinthApp",
    "Mozilla", "mpv", "Mullvad", "Narrator", "Nextcloud", "Notepad++", "npm",
    "NuGet", "NZXT CAM", "obs-studio", "obsidian", "Obsidian Tools",
    "org.asyar.app", "ow-electron", "Parsec", "Podman Desktop", "Postman",
    "Proton Mail", "Proton Pass", "powershell", "RealVNC", "RustDesk",
    "Signal", "SoundSwitch", "Spotify", "Stirling-PDF", "stirling.pdf.dev",
    "stoat-desktop", "TeamSpeak", "TeamViewer", "Telegram Desktop",
    "The MouseMux Company", "Thunderstore Mod Manager", "TS3Client",
    "Visual Studio Setup", "VoiceAccess", "VSCodium", "wago-app", "Waterfox",
    "weakauras-companion", "wezterm", "Wireshark", "WizTree3", "Z-Library",
    "zen", "Zoom", "calibre", "CurseForge", "EMPRESS", "Godot",
    "GOG Galaxy Notifications Renderer", "GalaxyClient",
    "MarvelRivals_Launcher", "r2modman", "Vortex"
)

# Roots to pull from. LocalLow / My Games / Saved Games are almost entirely
# game data on this machine, so they're copied wholesale.
$roots = @(
    @{ Name = "AppData_LocalLow"; Path = "$oldRoot\AppData\LocalLow"; Exclude = @("Temp", "webviewdata") }
    @{ Name = "Documents_My_Games"; Path = "$oldRoot\Documents\My Games"; Exclude = @() }
    @{ Name = "Saved_Games"; Path = "$oldRoot\Saved Games"; Exclude = @() }
    @{ Name = "AppData_Local"; Path = "$oldRoot\AppData\Local"; Exclude = $localExclude }
    @{ Name = "AppData_Roaming"; Path = "$oldRoot\AppData\Roaming"; Exclude = $roamingExclude }
)

if (Test-Path $log) {
    Remove-Item $log -Force
}

foreach ($root in $roots) {
    if (-not (Test-Path $root.Path)) {
        Write-Warning "Skipping missing path: $($root.Path)"
        continue
    }

    Write-Host "==> Copying $($root.Name) from $($root.Path)"

    $dest = Join-Path $stage $root.Name
    $xd = $root.Exclude | ForEach-Object { Join-Path $root.Path $_ }

    if ($xd.Count -gt 0) {
        robocopy $root.Path $dest /E /B /XJ /R:1 /W:1 /XD $xd /LOG+:$log /TEE /NP
    } else {
        robocopy $root.Path $dest /E /B /XJ /R:1 /W:1 /LOG+:$log /TEE /NP
    }

    $rc = $LASTEXITCODE
    if ($rc -ge 16) {
        throw "robocopy failed with a serious error (exit code $rc) copying $($root.Path). See $log"
    }
    if ($rc -ge 8) {
        Write-Warning "robocopy completed with some file errors (exit code $rc) copying $($root.Path) - likely locked/in-use files. See $log for details."
    }
}

$7z = "C:\Program Files\7-Zip\7z.exe"
if (-not (Test-Path $7z)) {
    $cmd = Get-Command 7z.exe -ErrorAction SilentlyContinue
    if (-not $cmd) {
        throw "7-Zip not found at '$7z' and 7z.exe is not on PATH."
    }
    $7z = $cmd.Source
}

if (Test-Path $zip) {
    Remove-Item $zip -Force
}

& $7z a -tzip $zip "$stage\*" | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "7-Zip failed with exit code $LASTEXITCODE"
}

Remove-Item $stage -Recurse -Force

Write-Host "Backup complete: $zip"
