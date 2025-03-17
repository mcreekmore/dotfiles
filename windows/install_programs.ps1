$winget_packages = @(
  "Audacity.Audacity",
  "AutoHotkey.AutoHotkey",
  "Bitwarden.Bitwarden",
  "Brave.Brave",
  "twpayne.chezmoi",
  "Google.ChromeRemoteDesktopHost",
  "CPUID.CPU-Z",
  "Citrix.Workspace",
  "Discord.Discord",
  "Docker.DockerDesktop",
  "ElectronicArts.EADesktop",
  "Element.Element",
  "Mozilla.Firefox",
  "GIMP.GIMP",
  "GOG.Galaxy",
  "Google.Chrome",
  "Google.GoogleDrive",
  "CPUID.HWMonitor",
  "KeePassXCTeam.KeePassXC",
  "Malwarebytes.Malwarebytes",
  "Microsoft.WindowsTerminal",
  "MullvadVPN.MullvadVPN",
  "OBSProject.OBSStudio",
  "Obsidian.Obsidian",
  "Parsec.Parsec",
  "Playnite.Playnite",
  "Plex.Plex",
  "Plex.Plexamp",
  "Microsoft.PowerToys",
  "Rufus.Rufus",
  "RuneLite.RuneLite",
  "OpenWhisperSystems.Signal",
  "SlackTechnologies.Slack",
  "AntoineAflalo.SoundSwitch",
  "Spotify.Spotify",
  "Starship.Starship",
  "Valve.Steam",
  "gerardog.gsudo",
  "Tailscale.Tailscale",
  "TeamViewer.TeamViewer",
  "Ubisoft.Connect",
  "Telegram.TelegramDesktop",
  "VideoLAN.VLC",
  "RealVNC.VNCViewer",
  "NexusMods.Vortex",
  "Microsoft.VisualStudioCode",
  "wez.wezterm",
  "WinDirStat.WinDirStat",
  "AntibodySoftware.WizTree",
  "Zoom.Zoom",
  "TechPowerUp.GPU-Z",
  "Hibbiki.Chromium"
)

# Check if Winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "Error: Winget is not installed or not in PATH" -ForegroundColor Red
  exit 1
}

foreach ($package in $winget_packages) {
  # Check if package is already installed
  try {
    $null = winget list --exact --id $package --accept-source-agreements
    $installed = $LASTEXITCODE -eq 0
  } catch {
    $installed = $false
  }

  if ($installed) {
    Write-Host "[✓] $package is already installed" -ForegroundColor Green
    continue
  }

  # Attempt installation
  Write-Host "[...] Installing $package" -ForegroundColor Cyan
  try {
    winget install --exact --id $package --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
      throw "Exit code: $LASTEXITCODE"
    }
    Write-Host "[✓] Successfully installed $package" -ForegroundColor Green
  } catch {
    Write-Host "[X] Failed to install $package ($($_.Exception.Message))" -ForegroundColor Red
  }
}

Write-Host "`nInstallation process completed" -ForegroundColor Cyan