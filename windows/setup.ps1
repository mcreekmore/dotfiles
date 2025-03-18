# get the directory of the current script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Set env variables
# [environment]::setEnvironmentVariable('SCOOP', 'C:\scoop', 'User')
[environment]::setEnvironmentVariable('EDITOR', 'code', 'User')
[environment]::setEnvironmentVariable('STARSHIP_CONFIG', '${USERPROFILE}\.config\starship\starship.toml', 'User')

# copy powershell profile location
$powershellProfilePath = Join-Path -Path $scriptDir -ChildPath ".\Microsoft.PowerShell_profile.ps1"
Copy-Item $powershellProfilePath -Destination "$PROFILE"

# set timezone
Set-TimeZone -Id "Eastern Standard Time"

<#
    .SYNOPSIS
    Install winget programs
#>

Write-Host "`nStarting Winget Package Installation..." -ForegroundColor Cyan

# Check if Winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Winget is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# define the path to the packages file
$wingetPackagesFile = Join-Path -Path $scriptDir -ChildPath "winget_packages.txt"

# check if the file exists and load the array
if (Test-Path -Path $wingetPackagesFile) {
    $winget_packages = Get-Content -Path $wingetPackagesFile | 
    Where-Object { $_.Trim() -notmatch '^#' -and $_.Trim() -ne '' }
} else {
    Write-Warning "Packages file not found: $wingetPackagesFile"
    $winget_packages = @()
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

Write-Host "`nWinget installation process completed" -ForegroundColor Cyan

<#
    .SYNOPSIS
    Install chocolatey and programs
#>

# install chocolatey

Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "`n[✓] Chocolatey is already installed." -ForegroundColor Green
}

# define the path to the packages file
$chocoPackagesFile = Join-Path -Path $scriptDir -ChildPath "choco_packages.txt"

# check if the file exists and load the array
if (Test-Path -Path $chocoPackagesFile) {
    $choco_packages = Get-Content -Path $chocoPackagesFile | 
    Where-Object { $_.Trim() -notmatch '^#' -and $_.Trim() -ne '' }
} else {
    Write-Warning "Packages file not found: $chocoPackagesFile"
    $choco_packages = @()
}

# install packages with formatted output
Write-Host "`nStarting Choco Package Installation..." -ForegroundColor Cyan
foreach ($package in $choco_packages) {
    # Check if package is already installed
    try {
        $installedOutput = choco list --exact --local-only $package -r -ErrorAction Stop
        $installed = [bool]$installedOutput
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
        choco install $package -y --acceptlicense --no-progress --fail-on-error-output --erroraction stop
        if ($LASTEXITCODE -ne 0) {
            throw "Exit code: $LASTEXITCODE"
        }
        Write-Host "[✓] Successfully installed $package" -ForegroundColor Green
    } catch {
        Write-Host "[X] Failed to install $package ($($_.Exception.Message))" -ForegroundColor Red
    }
}

Write-Host "`nChoco installation process completed" -ForegroundColor Cyan

<#
    .SYNOPSIS
    Install scoop and its packages/buckets
#>

# install scoop
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
    Write-Host "`n[✓] Scoop is already installed." -ForegroundColor Green
}

# define paths to the buckets and packages files
$bucketsFile = Join-Path -Path $scriptDir -ChildPath "scoop_buckets.txt"
$scoopPackagesFile = Join-Path -Path $scriptDir -ChildPath "scoop_packages.txt"

Write-Host "`nStarting Scoop Bucket Installation..." -ForegroundColor Cyan
if (Test-Path -Path $bucketsFile) {
    # Get list of installed buckets
    $installedBuckets = & scoop bucket list | ForEach-Object { $_.Name }
    
    Get-Content -Path $bucketsFile | ForEach-Object {
        $line = $_.Trim()
        if (-not $line -or $line -match '^#') { return }

        $parts = $line -split '\s+', 2
        $bucketName = $parts[0]
        $bucketUrl = if ($parts.Count -gt 1) { $parts[1] } else { $null }

        if ($bucketName -in $installedBuckets) {
            Write-Host "[✓] Bucket '$bucketName' is already installed" -ForegroundColor Green
            return
        }

        # Attempt bucket addition
        Write-Host "[...] Adding bucket '$bucketName'" -ForegroundColor Cyan
        try {
            if ($bucketUrl) {
                & scoop bucket add $bucketName $bucketUrl
            } else {
                & scoop bucket add $bucketName
            }
            
            if ($LASTEXITCODE -ne 0) {
                throw "Exit code: $LASTEXITCODE"
            }
            Write-Host "[✓] Successfully added bucket '$bucketName'" -ForegroundColor Green
        } catch {
            Write-Host "[X] Failed to add bucket '$bucketName' ($($_.Exception.Message))" -ForegroundColor Red
        }
    }
} else {
    Write-Host "[X] Buckets file not found: $bucketsFile" -ForegroundColor Red
}

# Load packages from file
Write-Host "`nChecking Packages Configuration..." -ForegroundColor Cyan
if (Test-Path -Path $scoopPackagesFile) {
    $scoop_packages = Get-Content -Path $scoopPackagesFile | 
    Where-Object { $_.Trim() -notmatch '^#' -and $_.Trim() -ne '' }
    Write-Host "[✓] Found $(@($scoop_packages).Count) packages to process" -ForegroundColor Green
} else {
    Write-Host "[!] Packages file not found: $scoopPackagesFile" -ForegroundColor Yellow
    $scoop_packages = @()
}

<#
    .SYNOPSIS
    Post install setup
#>

# set up bitwarden
if ($env:BW_SESSION -and $env:BW_SESSION -ne "") {
    Write-Host "BW_SESSION already exists. Skipping Bitwarden setup." -ForegroundColor Yellow
} else {
    Write-Host "`nStarting Bitwarden setup..." -ForegroundColor Cyan
    try {
        bw config server https://vault.creekmore.io
        bw login
        $env:BW_SESSION = (bw unlock --raw)
        bw sync
        Write-Host "`n[✓] Successfully initialized Bitwarden" -ForegroundColor Green
    } catch {
        Write-Host "`n[X] Failed to initialize Bitwarden: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# setup dotfiles
Write-Host "`nStarting chezmoi dotfiles sync..." -ForegroundColor Cyan
try {
    chezmoi init --apply --verbose https://github.com/mcreekmore/dotfiles.git
    Write-Host "[✓] Successfully initialized chezmoi" -ForegroundColor Green
} catch {
    Write-Host "[X] Failed to initialize chezmoi: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nStarting AutoHotKey Shortcut Creation..." -ForegroundColor Cyan

$startupProgramsPath = "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Minimize CTRL + F1.lnk"
$targetScriptPath = Join-Path -Path $scriptDir -ChildPath "\ahk\Minimize CTRL + F1.ahk"

if (Test-Path -Path $startupProgramsPath) {
    Write-Host "[✓] Symbolic link already exists at $startupProgramsPath" -ForegroundColor Green
} else {
    Write-Host "[...] Creating shortcut 'Minimize CTRL + F1.lnk'..." -ForegroundColor Cyan
    try {
        New-Item -ItemType SymbolicLink -Path $startupProgramsPath -Name "Minimize CTRL + F1.lnk" -Value $targetScriptPath -ErrorAction Stop
        Write-Host "[✓] Successfully created startup shortcut" -ForegroundColor Green
    } catch {
        Write-Host "[X] Failed to create shortcut: $($_.Exception.Message)" -ForegroundColor Red
    }
}