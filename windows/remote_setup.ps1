if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Restarting with administrator privileges..." -ForegroundColor Yellow
    if ($PSCommandPath) {
        Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    } else {
        $remoteSetupUrl = "https://raw.githubusercontent.com/mcreekmore/dotfiles/main/windows/remote_setup.ps1"
        Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"irm $remoteSetupUrl | iex`""
    }
    exit
}

$bwConfigServer = "https://vault.creekmore.io"
$maxLoginAttempts = 3

# Check if Winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Winget is not installed or not in PATH" -ForegroundColor Red
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# Install Git
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
        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    } catch {
        Write-Host "[X] Failed to install Git.Git ($($_.Exception.Message))" -ForegroundColor Red
    }
}

# Install chezmoi
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
        # Refresh PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    } catch {
        Write-Host "[X] Failed to install twpayne.chezmoi ($($_.Exception.Message))" -ForegroundColor Red
    }
}

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
try {
    $null = winget list --exact --id Bitwarden.CLI --accept-source-agreements
    $bitwardenInstalled = $LASTEXITCODE -eq 0
} catch {
    $bitwardenInstalled = $false
}
if ($bitwardenInstalled) { 
    Write-Host "[✓] Bitwarden is already installed." -ForegroundColor Green
} else {
    Write-Host "[...] Installing Bitwarden CLI" -ForegroundColor Cyan
    try {
        winget install --exact --id Bitwarden.CLI --silent --accept-package-agreements --accept-source-agreements
        if ($LASTEXITCODE -ne 0) {
            throw "Exit code: $LASTEXITCODE"
        }

        Write-Host "[✓] Successfully installed Bitwarden.CLI" -ForegroundColor Green
        
        # Refresh PATH after installation
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        
        # Verify installation worked
        if (-not (Get-Command bw -ErrorAction SilentlyContinue)) {
            throw "Failed to install Bitwarden CLI"
        }
        
        Write-Host "[✓] Successfully installed Bitwarden CLI" -ForegroundColor Green
    } catch {
        Write-Host "[X] Failed to install Bitwarden CLI: $($_.Exception.Message)" -ForegroundColor Red
        Read-Host -Prompt "Press Enter to continue without Bitwarden"
    }
}

# Configure Bitwarden
if (Get-Command bw -ErrorAction SilentlyContinue) {
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
    # Verify chezmoi is available
    if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
        throw "chezmoi command is not available in PATH"
    }
    
    chezmoi init --apply https://github.com/mcreekmore/dotfiles.git
    Write-Host "[✓] Successfully initialized chezmoi" -ForegroundColor Green
} catch {
    Write-Host "[X] Failed to initialize chezmoi: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nFinished setup" -ForegroundColor Cyan
Read-Host -Prompt "Press Enter to exit"