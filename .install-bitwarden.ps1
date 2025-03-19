# Check if Bitwarden is already installed
if (Get-Command bw -ErrorAction SilentlyContinue) { 
  Write-Host "Bitwarden is already installed."
  exit 0 
}

# Check if winget is available
if (Get-Command winget -ErrorAction SilentlyContinue) {
  Write-Host "Installing Bitwarden using winget..."
  winget install -e --id Bitwarden.CLI
} else {
  Write-Host "winget not found. Please install Bitwarden manually."
  exit 1
}

try {
  bw config server https://vault.creekmore.io
  bw login
  [Environment]::SetEnvironmentVariable("BW_SESSION", (bw unlock --raw), "User")
  $env:BW_SESSION = [Environment]::GetEnvironmentVariable("BW_SESSION", "User")
  bw sync
  Write-Host "`n[✓] Successfully initialized Bitwarden" -ForegroundColor Green
} catch {
  Write-Host "`n[X] Failed to initialize Bitwarden: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Bitwarden installation complete"
exit 0