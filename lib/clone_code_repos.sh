#!/usr/bin/env bash
# Clones git repos declared in code/repos.txt into ~/code.
#
# Uses `git init` + `remote add` + `fetch` + `checkout` instead of `git clone`
# because chezmoi may have already seeded these directories with private files
# (e.g. .env), which would make a plain clone refuse to run on a non-empty dir.
clone_code_repos() {
  local manifest="$HOME/code/repos.txt"
  [ -f "$manifest" ] || return 0

  local name url dir branch
  while read -r name url; do
    [[ -z "$name" || "$name" == \#* ]] && continue

    dir="$HOME/code/$name"
    if [ -d "$dir/.git" ]; then
      echo "$name is already cloned."
      continue
    fi

    echo "Cloning $name..."
    mkdir -p "$dir"
    git -C "$dir" init -q
    git -C "$dir" remote add origin "$url"
    git -C "$dir" fetch -q origin
    git -C "$dir" remote set-head origin -a
    branch=$(git -C "$dir" symbolic-ref --short refs/remotes/origin/HEAD | sed 's|^origin/||')
    git -C "$dir" checkout -q -t "origin/$branch"
  done < "$manifest"
}
