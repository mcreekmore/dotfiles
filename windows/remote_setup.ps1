# Check if Winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Winget is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Git.Git package
try {
    $null = winget list --exact --id Git.Git --accept-source-agreements
    $gitInstalled = $LASTEXITCODE -eq 0
} catch {
    $gitInstalled = $false
}

if ($gitInstalled) {
    Write-Host "[✓] Git.Git is already installed" -ForegroundColor Green
} else {
    Write-Host "[...] Installing Git.Git" -ForegroundColor Cyan
    try {
        winget install --exact --id Git.Git --silent --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) {
            throw "Exit code: $LASTEXITCODE"
        }
        Write-Host "[✓] Successfully installed Git.Git" -ForegroundColor Green
    } catch {
        Write-Host "[X] Failed to install Git.Git ($($_.Exception.Message))" -ForegroundColor Red
    }
}

# twpayne.chezmoi package
try {
    $null = winget list --exact --id twpayne.chezmoi --accept-source-agreements
    $chezmoiInstalled = $LASTEXITCODE -eq 0
} catch {
    $chezmoiInstalled = $false
}

if ($chezmoiInstalled) {
    Write-Host "[✓] twpayne.chezmoi is already installed" -ForegroundColor Green
} else {
    Write-Host "[...] Installing twpayne.chezmoi" -ForegroundColor Cyan
    try {
        winget install --exact --id twpayne.chezmoi --silent --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) {
            throw "Exit code: $LASTEXITCODE"
        }
        Write-Host "[✓] Successfully installed twpayne.chezmoi" -ForegroundColor Green
    } catch {
        Write-Host "[X] Failed to install twpayne.chezmoi ($($_.Exception.Message))" -ForegroundColor Red
    }
}

Write-Host "`nWinget installation process completed" -ForegroundColor Cyan

# Check if Bitwarden is already installed
if (Get-Command bw -ErrorAction SilentlyContinue) { 
    Write-Host "Bitwarden is already installed."
    exit 0 
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

# Setup dotfiles
Write-Host "`nStarting chezmoi dotfiles sync..." -ForegroundColor Cyan
try {
    chezmoi init --apply https://github.com/mcreekmore/dotfiles.git
    Write-Host "[✓] Successfully initialized chezmoi" -ForegroundColor Green
} catch {
    Write-Host "[X] Failed to initialize chezmoi: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "`nFinish setup via ~\windows\setup.ps1" -ForegroundColor Cyan