# DeveloperSetup

Ansible-based provisioning for my personal Ubuntu development environment. Running one script takes a fresh Ubuntu machine to a fully configured dev box: CLI tooling, Docker, cloud CLIs, Kubernetes tooling, Terraform/Terragrunt, git config, shell aliases, and VS Code.

## Requirements

- Ubuntu (or an Ubuntu-based environment, e.g. WSL2)
- `sudo` access
- `ansible` on `PATH` (`provision_environment.sh` installs it automatically on first run if missing)

## Quick start

```bash
./provision_environment.sh
```

This will:

1. Wipe and reinstall Ansible roles/collections from `ansible/ansible_requirements.yaml` into `~/.ansible/roles`.
2. Run `ansible-playbook` locally (`--connection=local`, inventory `127.0.0.1`) using `vars.yaml` as extra vars, prompting for your `sudo` password.

### After the first run: set your GitHub token

The `git` role installs `python3-keyring` and `python3-keyrings.alt` (the latter is a fallback backend for environments with no Secret Service daemon, e.g. WSL) and configures git's HTTPS credential helper to read your GitHub token from the OS keyring. Once provisioning has run at least once, store your token:

```bash
keyring set github_token <github.com/your-username>
```

Paste a GitHub Personal Access Token (classic, `repo` scope, or a fine-grained token scoped to the repos you need) when prompted. On WSL/headless systems this also prompts for a separate keyring passphrase the first time (to encrypt the local file-based store) — that's independent of the GitHub token itself. Verify with `keyring get github_token <github.com/your-username>`.

## Configuration

All user-specific settings live in `vars.yaml`:

| Variable                          | Purpose                                                                                 |
| --------------------------------- | --------------------------------------------------------------------------------------- |
| `user_profile`                    | Selects which `ansible/profile_<name>.yaml` playbook to run (currently only `platform`) |
| `default_editor`                  | Default editor: git's `core.editor` and the shell's `$EDITOR`/`$VISUAL`                 |
| `git_user_name`, `git_user_email` | Global git identity                                                                     |
| `git_repositories`                | Repos to auto-clone into `~/projects` (or a custom `dest`)                              |
| `enable_k8s_prompt`               | Show the current kubectl context in the shell prompt                                    |

## What gets installed

Roles are applied in this order by `ansible/profile_platform.yaml`:

| Role            | What it does                                                                                                                                                                                                                                                            |
| --------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `aws`           | Installs AWS CLI v2, creates `~/.aws`                                                                                                                                                                                                                                   |
| `cli_utils`     | Base CLI packages (curl, jq, yq, htop, unzip, vim, etc.)                                                                                                                                                                                                                |
| `docker`        | Installs Docker Engine (via `nickjj.docker`) with custom bridge/address-pool flags, ECR credential helper, proxy config in `~/.docker/config.json`                                                                                                                      |
| `fzf`           | Installs fzf and wires up key bindings in `.bashrc`                                                                                                                                                                                                                     |
| `gcloud_cli`    | Adds the Google Cloud apt repo and installs `google-cloud-cli`                                                                                                                                                                                                          |
| `git`           | Installs git, sets global identity/editor/aliases, GitHub credential helper (via `keyring`), clones `git_repositories` into `~/projects`                                                                                                                                |
| `go`            | Installs `golang` from apt                                                                                                                                                                                                                                              |
| `iac-tools`     | Installs `tgswitch`/`tfswitch` (Terraform & Terragrunt version managers), `tflint`, sets up a shared Terraform plugin cache                                                                                                                                             |
| `k8s`           | Installs `kubectl` (+ bash completion), `k9s`, Helm (via snap) with `helm-git`/`helm-secrets` plugins, `kubectx`/`kubens`, and `krew` with plugins: ktop, stern, neat, tree, who-can, access-matrix, view-secret, outdated, resource-capacity, df-pv, node-shell, sniff |
| `tmux`          | Installs tmux, drops in `ansible/roles/tmux/files/tmux.conf`, auto-attaches every new terminal to a `default` tmux session                                                                                                                                              |
| `ubuntu_basics` | Passwordless `sudo`, a git-aware PS1 prompt, and a set of shell aliases (git/docker/k8s/terraform/tmux shortcuts) in `.bash_aliases`                                                                                                                                    |
| `vscode`        | Installs VS Code (desktop, via apt) and writes baseline `settings.json`                                                                                                                                                                                                 |

`install_helper` is a shared utility role (not applied directly) used by `iac-tools` and `k8s` to download a versioned release archive/binary, verify its checksum, and symlink it into `/usr/local/bin`.

## Repo layout

```
provision_environment.sh          # entry point
vars.yaml                         # user-specific variables
ansible/
  ansible_requirements.yaml       # galaxy roles/collections
  ansible_root_playbook.yaml      # imports the selected profile
  profile_platform.yaml           # role list for the "platform" profile
  roles/                          # one directory per role (see table above)
                                   # each role has its own README.md — see docs/role-readme-guide.md
docs/
  role-readme-guide.md            # template/rules for writing a role's README.md
```
