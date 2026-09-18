$bwConfigServer = "https://vault.creekmore.io"
$maxLoginAttempts = 3

# Check if Winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Winget is not installed or not in PATH" -ForegroundColor Red
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# ENV
[environment]::setEnvironmentVariable('EDITOR', 'code', 'User')
[environment]::setEnvironmentVariable('STARSHIP_CONFIG', '${USERPROFILE}\.config\starship\starship.toml', 'User')
[Environment]::SetEnvironmentVariable("DIRENV_CONFIG", "$env:APPDATA\direnv\conf", "User")
[Environment]::SetEnvironmentVariable("XDG_CACHE_HOME", "$env:APPDATA\direnv\cache", "User")
[Environment]::SetEnvironmentVariable("XDG_DATA_HOME", "$env:APPDATA\direnv\data", "User")
[Environment]::SetEnvironmentVariable("OLLAMA_HOST", "0.0.0.0:11434", "User")

# Set timezone
Set-TimeZone -Id "Eastern Standard Time"

function Install-WingetPackage {
    param(
        [Parameter(Mandatory)] [string]$Id
    )

    try {
        $null = winget list --exact --id $Id --accept-source-agreements
        $isInstalled = $LASTEXITCODE -eq 0
    } catch {
        $isInstalled = $false
    }

    if ($isInstalled) {
        Write-Host "[✓] $Id is already installed" -ForegroundColor Green
        return
    }

    Write-Host "[...] Installing $Id" -ForegroundColor Cyan
    try {
        winget install --exact --id $Id --silent --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) {
            throw "Exit code: $LASTEXITCODE"
        }
        Write-Host "[✓] Successfully installed $Id" -ForegroundColor Green
        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    } catch {
        Write-Host "[X] Failed to install $Id ($($_.Exception.Message))" -ForegroundColor Red
    }
}

Install-WingetPackage -Id "Git.Git"
Install-WingetPackage -Id "twpayne.chezmoi"

Write-Host "`nWinget installation process completed" -ForegroundColor Cyan

# Install scoop
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "[✓] Scoop is already installed" -ForegroundColor Green
} else {
    Write-Host "[...] Installing Scoop" -ForegroundColor Cyan
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        Write-Host "[✓] Successfully installed Scoop" -ForegroundColor Green
        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    } catch {
        Write-Host "[X] Failed to install Scoop ($($_.Exception.Message))" -ForegroundColor Red
    }
}

# Install and configure Bitwarden if needed
Install-WingetPackage -Id "Bitwarden.CLI"

if (-not (Get-Command bw -ErrorAction SilentlyContinue)) {
    Write-Host "[X] Bitwarden CLI is not available, skipping configuration" -ForegroundColor Red
} else {
    bw config server $bwConfigServer

    $attempt = 0
    $success = $false

    while (-not $success -and $attempt -lt $maxLoginAttempts) {
        $attempt++
        Write-Host "`n[...] Configuring Bitwarden (Attempt $attempt of $maxLoginAttempts)" -ForegroundColor Cyan

        try {
            $bwStatus = (bw status | ConvertFrom-Json).status

            if ($bwStatus -eq "unlocked") {
                Write-Host "[✓] Bitwarden is already unlocked" -ForegroundColor Green
                bw sync
                $success = $true
                continue
            } elseif ($bwStatus -eq "locked") {
                $bwSession = bw unlock --raw
            } else {
                $bwSession = bw login --raw
            }

            if (-not $bwSession) {
                Write-Host "[X] Failed to get valid session token. Please try again." -ForegroundColor Red
                if ($attempt -lt $maxLoginAttempts) {
                    $retry = Read-Host "Press Enter to retry or type 'exit' to quit"
                    if ($retry -eq "exit") {
                        Write-Host "Exiting Bitwarden setup." -ForegroundColor Yellow
                        break
                    }
                }
                continue
            }

            # If we get here, we have a valid session
            [Environment]::SetEnvironmentVariable("BW_SESSION", $bwSession, "User")
            $env:BW_SESSION = $bwSession
            bw sync
            Write-Host "[✓] Successfully initialized Bitwarden" -ForegroundColor Green
            $success = $true
        } catch {
            Write-Host "[X] Failed to initialize Bitwarden: $($_.Exception.Message)" -ForegroundColor Red

            if ($attempt -lt $maxLoginAttempts) {
                $retry = Read-Host "Press Enter to retry or type 'exit' to quit"
                if ($retry -eq "exit") {
                    Write-Host "Exiting Bitwarden setup." -ForegroundColor Yellow
                    break
                }
            }
        }
    }

    if (-not $success) {
        Write-Host "`n[X] Maximum attempts reached. Failed to configure Bitwarden." -ForegroundColor Red
        $continue = Read-Host "Continue with setup without Bitwarden? (y/n)"
        if ($continue -ne "y") {
            Write-Host "Exiting setup." -ForegroundColor Yellow
            Read-Host -Prompt "Press Enter to exit"
            exit 1
        }
    }
}

# Setup dotfiles
Write-Host "`nStarting chezmoi dotfiles sync..." -ForegroundColor Cyan
try {
    chezmoi init --apply --verbose https://github.com/mcreekmore/dotfiles.git
    Write-Host "[✓] Successfully initialized chezmoi" -ForegroundColor Green
} catch {
    Write-Host "[X] Failed to initialize chezmoi: $($_.Exception.Message)" -ForegroundColor Red
}

# chezmoi apply lands the windows/ folder at $env:USERPROFILE\windows
$appliedWindowsDir = Join-Path $env:USERPROFILE "windows"

# Copy powershell profile
$powershellProfilePath = Join-Path $appliedWindowsDir "Microsoft.PowerShell_profile.ps1"
if (Test-Path $powershellProfilePath) {
    Copy-Item $powershellProfilePath -Destination "$PROFILE"
} else {
    Write-Host "[X] PowerShell profile not found at $powershellProfilePath" -ForegroundColor Red
}

Write-Host "`nStarting AutoHotKey Shortcut Creation..." -ForegroundColor Cyan

$startupFolder = [Environment]::GetFolderPath("Startup")
$cmStartup = Join-Path $appliedWindowsDir "startup"

if (-not (Test-Path $cmStartup)) {
    Write-Host "[X] Startup folder not found at $cmStartup" -ForegroundColor Red
    return
}

Write-Host "`nLinking AHK scripts to Startup..." -ForegroundColor Cyan

$WshShell = New-Object -ComObject WScript.Shell

Get-ChildItem -Path $cmStartup -File | ForEach-Object {

    $targetPath = $_.FullName
    $shortcutName = "$($_.BaseName).lnk"
    $shortcutPath = Join-Path $startupFolder $shortcutName

    if (Test-Path $shortcutPath) {
        Write-Host "[✓] $shortcutName already exists" -ForegroundColor Green
    } else {
        try {
            $shortcut = $WshShell.CreateShortcut($shortcutPath)
            $shortcut.TargetPath = $targetPath
            $shortcut.WorkingDirectory = $cmStartup
            $shortcut.Save()

            Write-Host "[✓] Created $shortcutName" -ForegroundColor Green
        } catch {
            Write-Host "[X] Failed to create $shortcutName : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}
