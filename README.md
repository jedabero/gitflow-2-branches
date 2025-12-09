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

## Seeding the demo history
Run the provided script from the `develop` branch with a clean working tree:

```bash
./scripts/seed-history.sh
```

It will create feature branches, merges, release tags, and a hotfix, with timestamps spaced across September 2025.
