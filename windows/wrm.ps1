# Uninstall a winget package and remove it from chezmoi's packages.yaml
param([Parameter(Mandatory)][string]$Id)

winget uninstall --id $Id --exact --source winget
# 0x8A150014 = no installed package found - still worth untracking
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335212) { return }

$file  = Join-Path (chezmoi source-path) '.chezmoidata/packages.yaml'
$lines = [System.Collections.Generic.List[string]](Get-Content $file)

# packages.winget block = lines after "  winget:" indented deeper than the key
$start = $lines.IndexOf('  winget:')
if ($start -lt 0) { throw "packages.winget not found in $file" }
$end = $start + 1
while ($end -lt $lines.Count -and $lines[$end] -match '^(\s{3,}|\s*$)') { $end++ }

$entry = "^\s*-\s*(id:\s*)?$([regex]::Escape($Id))\s*$"
$i = $lines.FindIndex($start + 1, $end - $start - 1, { param($l) $l -match $entry })
if ($i -lt 0) {
  Write-Host "$Id not in packages.yaml"; return
}

# For "- id: X" entries, also drop the entry's extra keys (e.g. args:)
$indent = $lines[$i].IndexOf('-')
$count  = 1
while ($i + $count -lt $end -and $lines[$i + $count] -match "^\s{$($indent + 1),}[^\s-]") { $count++ }
$lines.RemoveRange($i, $count)
($lines -join "`r`n") + "`r`n" | Set-Content $file -NoNewline
Write-Host "Removed $Id from packages.yaml"
