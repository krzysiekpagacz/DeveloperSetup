# git

## General

Installs git and git-extras, configures global identity/aliases (from `vars.yaml`) and `core.editor` (from the shared `default_editor` var), sets up a GitHub credential helper backed by the OS keyring, ensures `~/projects` exists, and clones each repo listed in `git_repositories` into it. Also installs `python3-keyring` (backs the credential helper) and `python3-keyrings.alt`, a fallback keyring backend for environments without a Secret Service daemon (e.g. WSL) — without it, `keyring set`/`get` fails with `NoKeyringError`.

## What it installs

| Tool                 | Version      | Description                                                                                         |
| -------------------- | ------------ | --------------------------------------------------------------------------------------------------- |
| git                  | latest (apt) | Distributed version control system                                                                  |
| git-extras           | latest (apt) | Collection of extra git commands (e.g. `git summary`, `git effort`)                                 |
| python3-keyring      | latest (apt) | Python `keyring` CLI/library, used to store/retrieve the GitHub token for the credential helper     |
| python3-keyrings.alt | latest (apt) | Fallback keyring backends (file-based, incl. encrypted) for systems without a Secret Service daemon |
