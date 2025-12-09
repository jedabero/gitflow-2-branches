# Git Flow (Main + Develop) Demo

This repository will showcase a lightweight git-flow style history using only two long-lived branches: `main` and `develop`. No application code is included—just Markdown and commit history crafted to illustrate the model.

## Goals
- Show how `main` and `develop` evolve over time.
- Include feature branches merged into `develop` with `--no-ff`.
- Cut releases from `develop` into `main`, tag them, and back-merge to keep branches in sync.
- Demonstrate a hotfix taken directly from `main` and merged back.

## What will be here
- A scripted commit history with realistic timestamps.
- Narrative Markdown explaining each branch and merge.
- Tags for releases (e.g., `v1.0.0`, `v1.1.0`, `v1.1.1`).

## How to explore (after seeding)
```bash
git log --graph --oneline --decorate --all
```

## Next steps
1) Create `develop` from `main`.
2) Add a seeding script that builds the history with spaced timestamps.
3) Run the script to populate commits, merges, and tags.
