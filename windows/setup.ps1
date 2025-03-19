$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ENV
[environment]::setEnvironmentVariable('EDITOR', 'code', 'User')
[environment]::setEnvironmentVariable('STARSHIP_CONFIG', '${USERPROFILE}\.config\starship\starship.toml', 'User')

# Copy powershell profile location
$powershellProfilePath = Join-Path -Path $scriptDir -ChildPath ".\Microsoft.PowerShell_profile.ps1"
Copy-Item $powershellProfilePath -Destination "$PROFILE"

# Set timezone
Set-TimeZone -Id "Eastern Standard Time"

# Install prereqs
winget install --id Git.Git
winget install --id twpayne.chezmoi

# Setup dotfiles
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