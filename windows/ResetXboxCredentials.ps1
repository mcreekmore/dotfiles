# Remove-XboxCreds.ps1
# Deletes Credential Manager entries that appear to be related to Xbox / Xbox Live / gaming sign-in

$patterns = @(
  'xbox',
  'xbl',
  'xsts',
  'xboxlive',
  'gaming',
  'gamepass',
  'microsoftaccount:user='
)

Write-Host "Reading stored credentials from Credential Manager..." -ForegroundColor Cyan

$raw = cmdkey /list 2>$null

if (-not $raw) {
  Write-Error "Unable to read Credential Manager entries."
  exit 1
}

# Extract target names from cmdkey output
$targets = foreach ($line in $raw) {
  if ($line -match '^\s*Target:\s*(.+)$') {
    $matches[1].Trim()
  }
}

if (-not $targets) {
  Write-Host "No Credential Manager targets found." -ForegroundColor Yellow
  exit 0
}

# Filter likely Xbox-related entries
$toDelete = $targets | Where-Object {
  $t = $_.ToLowerInvariant()
  $patterns | Where-Object { $t -like "*$_*" }
} | Sort-Object -Unique

if (-not $toDelete) {
  Write-Host "No Xbox-related credentials matched the filter." -ForegroundColor Yellow
  exit 0
}

Write-Host ""
Write-Host "The following credential entries will be removed:" -ForegroundColor Yellow
$toDelete | ForEach-Object { Write-Host " - $_" }

Write-Host ""
$confirm = Read-Host "Type YES to delete these credentials"

if ($confirm -ne "YES") {
  Write-Host "Aborted. No credentials were removed." -ForegroundColor Yellow
  exit 0
}

foreach ($target in $toDelete) {
  Write-Host "Deleting: $target" -ForegroundColor Red
  cmdkey /delete:$target | Out-Null
}

Write-Host ""
Write-Host "Done. Matching Xbox-related Credential Manager entries were removed." -ForegroundColor Green
Write-Host "You may need to sign out and back in, or reboot, before all apps notice the change." -ForegroundColor Cyan