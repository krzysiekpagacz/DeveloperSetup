# git

## General

Installs git and git-extras, configures global identity/aliases (from `vars.yaml`) and `core.editor` (from the shared `default_editor` var), sets up a GitHub credential helper backed by the OS keyring, ensures `~/projects` exists, and clones each repo listed in `git_repositories` into it.

## What it installs

| Tool       | Version      | Description                                                         |
| ---------- | ------------ | ------------------------------------------------------------------- |
| git        | latest (apt) | Distributed version control system                                  |
| git-extras | latest (apt) | Collection of extra git commands (e.g. `git summary`, `git effort`) |
