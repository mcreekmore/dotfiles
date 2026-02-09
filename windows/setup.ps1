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

$startupFolder = [Environment]::GetFolderPath("Startup")
$cmStartup = Join-Path $scriptDir "startup"

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
