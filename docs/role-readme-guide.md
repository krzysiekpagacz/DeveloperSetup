# Role README Guide

Every directory under `ansible/roles/<role>/` has a `README.md` describing what the role does. This guide defines the template so documentation stays consistent as roles are added or changed — including for Claude, which should follow it automatically.

## When to apply this

- **New role**: whenever a new directory is created under `ansible/roles/`, add a `README.md` to it using the template below, and add a row for the role to the "What gets installed" table in the top-level `README.md`.
- **Changed role**: whenever a role's tasks change what it installs/configures, or a pinned version bumps, update that role's `README.md` in the same change.

## Template

```markdown
# <role name>

## General

<2-4 sentences: what this role configures/installs, when relevant note it needs `become: true`/sudo, and any files it manages (e.g. `.bashrc` blocks, config files, sudoers).>

## What it installs

| Tool     | Version                               | Description                        |
| -------- | ------------------------------------- | ---------------------------------- |
| `<tool>` | `<version, "latest (apt)", "latest">` | <one-line description of the tool> |
```

## Filling in "Version"

- If a role variable pins a version (e.g. `k8s_tools__kubectl_version`), use that variable's value.
- If installed via `apt`/`snap` with `state: latest`/`present` and no pinned version, write `latest (apt)` / `latest (snap)`.
- If a tool is installed indirectly by another tool the role manages (e.g. Terraform via `tfswitch`), still give it its own table row with its pinned version.
- If a tool comes from a plugin index with no per-plugin pinned version (e.g. krew plugins), write `latest (krew)`.

## Roles that don't fit the table

Some roles don't install a tool directly — they only edit config (`ubuntu_basics`) or are shared helpers included by other roles (`install_helper`). For these:

- Describe the actual behavior in **General**.
- Replace the table with a short note, e.g. "N/A — no tools installed directly" or "N/A — installs whatever the including role configures; see that role's README."

## Source of truth for facts

Don't guess versions or descriptions — read the role's `tasks/main.yaml` (and `defaults/main.yaml`/`vars/main.yaml` if present) to find pinned version variables and exactly what gets installed.
