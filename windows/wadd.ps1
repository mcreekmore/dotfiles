# Install a winget package and track it in chezmoi's packages.yaml
param([Parameter(Mandatory)][string]$Id)

winget install --id $Id --exact --source winget
# 0x8A15002B = already installed / no upgrade available - still worth tracking
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) { return }

$file  = Join-Path (chezmoi source-path) '.chezmoidata/packages.yaml'
$lines = [System.Collections.Generic.List[string]](Get-Content $file)

# packages.winget block = lines after "  winget:" indented deeper than the key
$start = $lines.IndexOf('  winget:')
if ($start -lt 0) { throw "packages.winget not found in $file" }
$end = $start + 1
while ($end -lt $lines.Count -and $lines[$end] -match '^(\s{3,}|\s*$)') { $end++ }

$entry = "^\s*-\s*(id:\s*)?$([regex]::Escape($Id))\s*$"
if ($lines.GetRange($start + 1, $end - $start - 1) -match $entry) {
  Write-Host "$Id already in packages.yaml"; return
}

# Insert after the last non-blank line of the block
while ($lines[$end - 1] -match '^\s*$') { $end-- }
$lines.Insert($end, "    - $Id")
($lines -join "`r`n") + "`r`n" | Set-Content $file -NoNewline
Write-Host "Added $Id to packages.yaml"
