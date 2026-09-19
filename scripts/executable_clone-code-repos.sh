#!/usr/bin/env bash
# Run manually (after you're signed in / authenticated for private repos) to
# clone the repos declared in code/repos.txt into ~/code.
set -euo pipefail

# shellcheck source=/dev/null
source "$HOME/lib/clone_code_repos.sh"
clone_code_repos
