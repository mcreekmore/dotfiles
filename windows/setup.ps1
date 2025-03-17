# get the directory of the current script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# copy powershell profile location
$powershellProfilePath = Join-Path -Path $scriptDir -ChildPath ".\Microsoft.PowerShell_profile.ps1"
Copy-Item $powershellProfilePath -Destination "$PROFILE"

# set timezone
Set-TimeZone -Id "Eastern Standard Time"

<#
    .SYNOPSIS
    Install winget programs
#>
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

Write-Host "`nInstallation process completed" -ForegroundColor Cyan



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
    Write-Host "Chocolatey is already installed."
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

foreach ($package in $choco_packages) {
    choco install $package -y
}

<#
    .SYNOPSIS
    Install scoop and its packages/buckets
#>

# set scoop env path
[environment]::setEnvironmentVariable('SCOOP', 'C:\scoop', 'User')

# define paths to the buckets and packages files
$bucketsFile = Join-Path -Path $scriptDir -ChildPath "scoop_buckets.txt"
$scoopPackagesFile = Join-Path -Path $scriptDir -ChildPath "scoop_packages.txt"

# add Scoop buckets if they are not already installed
if (Test-Path -Path $bucketsFile) {
    # get list of currently installed buckets
    $installedBuckets = & scoop bucket list | ForEach-Object { $_.Name }
    Get-Content -Path $bucketsFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -and $line -notmatch '^#') {
            $parts = $line -split '\s+', 2
            $bucketName = $parts[0]
            if ($bucketName -notin $installedBuckets) {
                if ($parts.Length -eq 2) {
                    $url = $parts[1]
                    Write-Host "Adding bucket '$bucketName' with URL '$url'..."
                    & scoop bucket add $bucketName $url
                } else {
                    Write-Host "Adding bucket '$bucketName'..."
                    & scoop bucket add $bucketName
                }
            } else {
                Write-Host "Bucket '$bucketName' is already installed."
            }
        }
    }
} else {
    Write-Warning "Buckets file not found: $bucketsFile"
}

# install Scoop packages
if (Test-Path -Path $scoopPackagesFile) {
    Get-Content -Path $scoopPackagesFile | ForEach-Object {
        $package = $_.Trim()
        if ($package -and $package -notmatch '^#') {
            Write-Host "Installing package '$package'..."
            & scoop install $package
        }
    }
} else {
    Write-Warning "Packages file not found: $scoopPackagesFile"
}

<#
    .SYNOPSIS
    Post install setup
#>

# setup dotfiles
chezmoi init --apply --verbose https://github.com/mcreekmore/dotfiles.git

# make shortcuts to auto start programs
$linkPath = "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\Minimize CTRL + F1.lnk"
$targetPath = Join-Path -Path $scriptDir -ChildPath "\ahk\Minimize CTRL + F1.ahk"

if (-not (Test-Path -Path $linkPath)) {
    New-Item -ItemType SymbolicLink -Path $linkPath -Name "Minimize CTRL + F1.lnk" -Value $targetPath
} else {
    Write-Host "Symbolic link already exists at $linkPath"
}