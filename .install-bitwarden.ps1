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

Write-Host "Bitwarden installation complete"
exit 0