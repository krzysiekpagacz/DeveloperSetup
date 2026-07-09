# git

## General

Installs git and git-extras, configures global identity/editor/aliases (from `vars.yaml`), sets up a GitHub credential helper backed by the OS keyring, ensures `~/projects` exists, and clones each repo listed in `git_repositories` into it.

## What it installs

| Tool       | Version      | Description                                                         |
| ---------- | ------------ | ------------------------------------------------------------------- |
| git        | latest (apt) | Distributed version control system                                  |
| git-extras | latest (apt) | Collection of extra git commands (e.g. `git summary`, `git effort`) |
