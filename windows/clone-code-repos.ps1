# Run manually (after you're signed in / authenticated for private repos) to
# clone the repos declared in code/repos.txt into %USERPROFILE%\code.
#
# Uses init+remote+fetch+checkout instead of `git clone` since chezmoi may have
# already seeded these directories with private files (e.g. .env), which would
# make a plain clone refuse to run on a non-empty directory.

$manifest = Join-Path $env:USERPROFILE "code\repos.txt"
if (-not (Test-Path $manifest)) {
    Write-Host "[X] No manifest found at $manifest" -ForegroundColor Red
    exit 1
}

Get-Content $manifest | ForEach-Object {
    $line = $_.Trim()
    if (-not $line -or $line.StartsWith("#")) {
        return
    }

    $name, $url = $line -split '\s+', 2
    $dir = Join-Path $env:USERPROFILE "code\$name"

    if (Test-Path (Join-Path $dir ".git")) {
        git -C $dir rev-parse --verify -q HEAD *>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[✓] $name is already cloned" -ForegroundColor Green
            return
        }
        Write-Host "[!] $name has a stale/incomplete .git (no commits checked out) - re-cloning" -ForegroundColor Yellow
        Remove-Item -Recurse -Force (Join-Path $dir ".git")
    }

    Write-Host "[...] Cloning $name" -ForegroundColor Cyan
    try {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null

        git -C $dir init -q
        if ($LASTEXITCODE -ne 0) { throw "git init failed" }

        git -C $dir remote add origin $url
        if ($LASTEXITCODE -ne 0) { throw "git remote add failed" }

        git -C $dir fetch -q origin
        if ($LASTEXITCODE -ne 0) { throw "git fetch failed (check auth/SSH agent)" }

        git -C $dir remote set-head origin -a
        if ($LASTEXITCODE -ne 0) { throw "git remote set-head failed" }

        $branch = (git -C $dir symbolic-ref --short refs/remotes/origin/HEAD) -replace '^origin/', ''
        if ($LASTEXITCODE -ne 0 -or -not $branch) { throw "could not determine default branch" }

        git -C $dir checkout -q -t "origin/$branch"
        if ($LASTEXITCODE -ne 0) { throw "git checkout failed" }

        Write-Host "[✓] Cloned $name" -ForegroundColor Green
    } catch {
        Write-Host "[X] Failed to clone $name ($($_.Exception.Message))" -ForegroundColor Red
        $gitDir = Join-Path $dir ".git"
        if (Test-Path $gitDir) {
            Remove-Item -Recurse -Force $gitDir
        }
    }
}
