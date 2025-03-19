# Check if Winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Winget is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

$winget_packages = @(
    "Git.Git",
    "twpayne.chezmoi"
)

# Attempt installation
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

Write-Host "`nWinget installation process completed" -ForegroundColor Cyan

if (Get-Command rustc -ErrorAction SilentlyContinue) {
    Write-Host "Rust is already installed." -ForegroundColor Yellow
    rustc --version
} else {
    Write-Host "Installing Rust..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri https://win.rustup.rs/x86_64 -OutFile "$env:TEMP\rustup-init.exe"
    Start-Process -FilePath "$env:TEMP\rustup-init.exe" -ArgumentList "-y", "--default-toolchain", "stable", "--profile", "minimal" -Wait
    $env:Path = [System.Environment]::GetEnvironmentVariable("PATH", "User") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
    Remove-Item -Path "$env:TEMP\rustup-init.exe"
    Write-Host "Rust installed successfully!" -ForegroundColor Green
}

rustc --version
cargo --version

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