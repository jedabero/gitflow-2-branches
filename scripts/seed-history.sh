#!/usr/bin/env bash
set -euo pipefail

# Seed a git-flow style history using only Markdown files.
# Assumes you're starting from the initial commit on `main`.

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT_DIR"

require_clean_tree() {
  if [[ -n $(git status --porcelain) ]]; then
    echo "Working tree is not clean. Commit or stash changes first." >&2
    exit 1
  fi
}

require_branch() {
  local expected=$1
  local current
  current=$(git symbolic-ref --short HEAD)
  if [[ $current != "$expected" ]]; then
    echo "Checkout '$expected' before running." >&2
    exit 1
  fi
}

require_absent_tag() {
  local tag=$1
  if git rev-parse -q --verify "refs/tags/$tag" >/dev/null; then
    echo "Tag '$tag' already exists; aborting to stay idempotent." >&2
    exit 1
  fi
}

set_dates() {
  local iso="$1"
  export GIT_AUTHOR_DATE="$iso"
  export GIT_COMMITTER_DATE="$iso"
}

add_log_entry() {
  local heading="$1"
  local body="$2"
  cat <<EOF >> HISTORY.md
## $heading

$body

---
EOF
}

commit_change() {
  local message="$1"
  git add README.md CHANGELOG.md HISTORY.md
  git commit -m "$message"
}

merge_no_ff() {
  local branch="$1"
  git checkout develop
  git merge --no-ff "$branch" -m "Merge $branch"
}

release() {
  local tag="$1"
  local date="$2"
  set_dates "$date"
  git checkout main
  git merge --no-ff develop -m "Release $tag"
  git tag "$tag"
  git checkout develop
  git merge --no-ff main -m "Back-merge $tag into develop"
}

hotfix() {
  local name="$1"; shift
  local date="$1"; shift
  local message="$1"; shift

  git checkout main
  git checkout -b "hotfix/$name"
  set_dates "$date"
  "$@"
  commit_change "$message"
  git checkout main
  git merge --no-ff "hotfix/$name" -m "Hotfix: $message"
  git tag "$HOTFIX_TAG"
  git checkout develop
  git merge --no-ff main -m "Back-merge hotfix $HOTFIX_TAG"
}

require_clean_tree
require_branch develop
require_absent_tag v1.1.1

START="2025-09-01 10:00:00"
HISTORY_FILE=HISTORY.md
touch $HISTORY_FILE

# Base copy tweaks on develop to set context
set_dates "2025-09-01 10:00:00"
add_log_entry "Setup" "Initialized documentation-only repo to model git-flow with main/develop."
commit_change "docs: establish history log"

############################
# Sprint 1 features
############################

# feature/landing-copy
git checkout -b feature/landing-copy
set_dates "2025-09-03 11:00:00"
add_log_entry "Feature: Landing copy" "Added overview of git-flow intent for stakeholders."
commit_change "docs: add landing copy note"
merge_no_ff feature/landing-copy

# feature/process-diagram (textual description)
git checkout -b feature/process-diagram
set_dates "2025-09-05 09:30:00"
add_log_entry "Feature: Process diagram" "Documented textual flow from feature branch -> develop -> main release."
commit_change "docs: describe process diagram"
merge_no_ff feature/process-diagram

# Release v1.0.0
release v1.0.0 "2025-09-08 14:00:00"

############################
# Sprint 2 features
############################

git checkout develop

# feature/faq
git checkout -b feature/faq
set_dates "2025-09-15 13:00:00"
add_log_entry "Feature: FAQ" "Captured common questions about branch strategy and merge rules."
commit_change "docs: add FAQ notes"
merge_no_ff feature/faq

# feature/cli-tips
git checkout -b feature/cli-tips
set_dates "2025-09-18 15:00:00"
add_log_entry "Feature: CLI tips" "Added commands for viewing history graph and tags."
commit_change "docs: add CLI tips"
merge_no_ff feature/cli-tips

# Release v1.1.0
release v1.1.0 "2025-09-22 10:00:00"

############################
# Hotfix from main
############################

HOTFIX_TAG=v1.1.1

hotfix typo "2025-09-25 09:00:00" "docs: correct release notes wording" \
  add_log_entry "Hotfix: Release notes wording" "Fixed minor typo discovered on main after v1.1.0."

git checkout develop

echo "History seeded through $HOTFIX_TAG."
