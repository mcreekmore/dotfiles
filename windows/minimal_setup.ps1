# Check if Winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Winget is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Attempt installation
Write-Host "[...] Installing $package" -ForegroundColor Cyan
try {
    winget install --exact --id twpayne.chezmoi --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        throw "Exit code: $LASTEXITCODE"
    }
    Write-Host "[✓] Successfully installed $package" -ForegroundColor Green
} catch {
    Write-Host "[X] Failed to install $package ($($_.Exception.Message))" -ForegroundColor Red
}

Write-Host "`nWinget installation process completed" -ForegroundColor Cyan

# Setup dotfiles
Write-Host "`nStarting chezmoi dotfiles sync..." -ForegroundColor Cyan
try {
    chezmoi init --apply --verbose https://github.com/mcreekmore/dotfiles.git
    Write-Host "[✓] Successfully initialized chezmoi" -ForegroundColor Green
} catch {
    Write-Host "[X] Failed to initialize chezmoi: $($_.Exception.Message)" -ForegroundColor Red
}
