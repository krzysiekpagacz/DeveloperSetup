# DeveloperSetup

Ansible-based provisioning for my personal Ubuntu development environment. Running one script takes a fresh Ubuntu machine to a fully configured dev box, installing and configuring around 55 tools across these areas:

- **Base CLI tooling** — curl, jq, yq, git(+extras), fzf, tmux, and other everyday utilities
- **Containers** — Docker Engine, Compose v2, ECR credential helper
- **Cloud CLIs** — AWS CLI v2, Google Cloud CLI
- **Kubernetes** — kubectl, k9s, Helm (+ plugins), kubectx/kubens, and 11 krew-managed kubectl plugins
- **Infrastructure as code** — Terraform/Terragrunt (via version-switchers) and tflint
- **Shell environment** — git-aware PS1 prompt, shell aliases, passwordless sudo
- **VS Code** — editor + extensions (only on setups that run Linux-desktop VS Code directly; see below)

Each of these is applied by an Ansible role under `ansible/roles/`; see [What gets installed](#what-gets-installed) for the role-by-role breakdown and the [full tool inventory](#full-tool-inventory) for every individual tool, version, and source role.

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
| `user_profile`                    | Selects which `profiles/profile_<name>.yaml` playbook to run (currently only `platform`) |
| `default_editor`                  | Default editor: git's `core.editor` and the shell's `$EDITOR`/`$VISUAL`                 |
| `git_user_name`, `git_user_email` | Global git identity                                                                     |
| `git_repositories`                | Repos to auto-clone into `~/projects` (or a custom `dest`)                              |
| `enable_k8s_prompt`               | Show the current kubectl context in the shell prompt                                    |

## What gets installed

Roles are applied in this order by `profiles/profile_platform.yaml`:

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
| `loki`          | Downloads and installs the Grafana Loki binary (v3.7.3) via `install_helper`, verified against the upstream `SHA256SUMS` checksum                                                                                                                                       |
| `tmux`          | Installs tmux, drops in `ansible/roles/tmux/files/tmux.conf`, auto-attaches every new terminal to a `default` tmux session                                                                                                                                              |
| `ubuntu_basics` | Passwordless `sudo`, a git-aware PS1 prompt (with exit-status indicator and, when enabled, kubectl context:namespace), and a set of shell aliases (git/docker/k8s/terraform/tmux shortcuts) in `.bash_aliases`                                                          |

`install_helper` is a shared utility role (not applied directly) used by `iac-tools` and `k8s` to download a versioned release archive/binary, verify its checksum, and symlink it into `/usr/local/bin`.

`vscode` is also present but **not applied** by the `platform` profile: on WSL with the standard Windows VS Code + Remote-WSL workflow, VS Code's settings and extensions live outside this WSL filesystem entirely (Windows side, and `~/.vscode-server` which only exists after the first Remote-WSL connection), so there's nothing useful for this repo to manage there. If that's your setup, add the extensions and settings below on the Windows side instead. The role stays available for setups that run the Linux desktop VS Code directly inside WSL (e.g. via WSLg) or on a non-WSL Ubuntu box — see `ansible/roles/vscode/README.md`.

### Full tool inventory

Every individual tool installed by the roles above (each role's own `README.md` is the source of truth — this table just flattens them into one place). "Folder" is the role directory under `ansible/roles/` that installs it. Versions come from the pinning variable a role uses where one exists; `latest (apt)`/`latest (snap)`/`latest (krew)` means the role installs whatever that package source currently serves.

| Tool                          | Version                                         | Folder                     | Description                                                                                                                              |
| ----------------------------- | ----------------------------------------------- | -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| AWS CLI                       | latest                                          | `ansible/roles/aws`        | Official AWS CLI v2, installed via AWS's own installer script (always current)                                                           |
| apt-transport-https           | latest (apt)                                    | `ansible/roles/cli_utils`  | HTTPS transport for apt package management                                                                                               |
| bash-completion               | latest (apt)                                    | `ansible/roles/cli_utils`  | Programmable tab-completion for bash                                                                                                     |
| coreutils                     | latest (apt)                                    | `ansible/roles/cli_utils`  | GNU core utilities (`ls`, `cat`, etc.)                                                                                                   |
| curl                          | latest (apt)                                    | `ansible/roles/cli_utils`  | Command-line HTTP/file transfer client                                                                                                   |
| gnupg                         | latest (apt)                                    | `ansible/roles/cli_utils`  | GPG encryption/signing toolkit, used for apt repo keys                                                                                   |
| graphviz                      | latest (apt)                                    | `ansible/roles/cli_utils`  | Graph visualization tools (`dot`), used by tools like `terraform graph`                                                                  |
| htop                          | latest (apt)                                    | `ansible/roles/cli_utils`  | Interactive process/resource viewer                                                                                                      |
| jq                            | latest (apt)                                    | `ansible/roles/cli_utils`  | Command-line JSON processor                                                                                                              |
| lsb-release                   | latest (apt)                                    | `ansible/roles/cli_utils`  | Reports Linux Standard Base / distribution info                                                                                          |
| moreutils                     | latest (apt)                                    | `ansible/roles/cli_utils`  | Extra Unix utilities, including `sponge`                                                                                                 |
| python3-pip                   | latest (apt)                                    | `ansible/roles/cli_utils`  | Python 3 package installer                                                                                                               |
| ssh                           | latest (apt)                                    | `ansible/roles/cli_utils`  | OpenSSH client/server                                                                                                                    |
| tar                           | latest (apt)                                    | `ansible/roles/cli_utils`  | Archive utility                                                                                                                          |
| unzip                         | latest (apt)                                    | `ansible/roles/cli_utils`  | Zip archive extractor                                                                                                                    |
| vim                           | latest (apt)                                    | `ansible/roles/cli_utils`  | Text editor (also configured as the default git editor)                                                                                  |
| wget                          | latest (apt)                                    | `ansible/roles/cli_utils`  | Command-line file downloader                                                                                                             |
| yq                            | latest (apt)                                    | `ansible/roles/cli_utils`  | Command-line YAML processor                                                                                                              |
| Docker Engine                 | latest (via `nickjj.docker`)                    | `ansible/roles/docker`     | Container runtime and CLI (`dockerd` + `docker`)                                                                                         |
| Docker Compose v2             | latest (via `nickjj.docker`)                    | `ansible/roles/docker`     | Multi-container orchestration plugin (`docker compose`)                                                                                  |
| docker (Python SDK)           | 4.4.4                                           | `ansible/roles/docker`     | Python client library for the Docker Engine API, used by Ansible's docker-family modules                                                 |
| amazon-ecr-credential-helper  | latest (apt)                                    | `ansible/roles/docker`     | Docker credential helper for authenticating to Amazon ECR                                                                                |
| fzf                           | latest (apt)                                    | `ansible/roles/fzf`        | Command-line fuzzy finder, wired into bash via Ctrl-R/Ctrl-T key bindings                                                                |
| google-cloud-cli              | latest (apt)                                    | `ansible/roles/gcloud_cli` | Google Cloud SDK CLI (`gcloud`) for managing GCP resources                                                                               |
| git                           | latest (apt)                                    | `ansible/roles/git`        | Distributed version control system                                                                                                       |
| git-extras                    | latest (apt)                                    | `ansible/roles/git`        | Collection of extra git commands (e.g. `git summary`, `git effort`)                                                                      |
| python3-keyring               | latest (apt)                                    | `ansible/roles/git`        | Python `keyring` CLI/library, used to store/retrieve the GitHub token for the credential helper                                          |
| python3-keyrings.alt          | latest (apt)                                    | `ansible/roles/git`        | Fallback keyring backends (file-based, incl. encrypted) for systems without a Secret Service daemon                                      |
| golang                        | latest (apt)                                    | `ansible/roles/go`         | Go programming language compiler/toolchain                                                                                               |
| tgswitch                      | 0.6.0                                           | `ansible/roles/iac-tools`  | Version manager/switcher for Terragrunt                                                                                                  |
| terragrunt                    | v1.1.0                                          | `ansible/roles/iac-tools`  | Thin wrapper for Terraform for keeping configurations DRY (installed via tgswitch)                                                       |
| tfswitch (terraform-switcher) | v1.19.0                                         | `ansible/roles/iac-tools`  | Version manager/switcher for Terraform                                                                                                   |
| terraform                     | 1.15.8                                          | `ansible/roles/iac-tools`  | Infrastructure-as-code provisioning tool (installed via tfswitch)                                                                        |
| tflint                        | v0.63.1                                         | `ansible/roles/iac-tools`  | Terraform linter for detecting errors and enforcing best practices                                                                       |
| kubectl                       | v1.36.2                                         | `ansible/roles/k8s`        | Kubernetes command-line client                                                                                                           |
| k9s                           | v0.51.0                                         | `ansible/roles/k8s`        | Terminal UI for managing Kubernetes clusters                                                                                             |
| Helm                          | latest (snap)                                   | `ansible/roles/k8s`        | Kubernetes package manager                                                                                                               |
| helm-git                      | v1.5.2                                          | `ansible/roles/k8s`        | Helm plugin — use git repos as chart sources                                                                                             |
| helm-secrets                  | v4.7.7                                          | `ansible/roles/k8s`        | Helm plugin — encrypt/decrypt secret values files                                                                                        |
| kubectx                       | v0.11.0                                         | `ansible/roles/k8s`        | Fast Kubernetes context switcher                                                                                                         |
| kubens                        | v0.11.0                                         | `ansible/roles/k8s`        | Fast Kubernetes namespace switcher                                                                                                       |
| krew                          | v0.5.0                                          | `ansible/roles/k8s`        | Plugin manager for kubectl                                                                                                               |
| kubectl-ktop                  | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — real-time CPU/memory usage per pod/node, like `top` for Kubernetes                                           |
| kubectl-stern                 | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — tail logs from multiple pods/containers with color-coded, filterable output                                  |
| kubectl-neat                  | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — cleans `kubectl get -o yaml` output of managed fields/status noise                                           |
| kubectl-tree                  | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — shows the ownership hierarchy of resources (e.g. Deployment → ReplicaSet → Pod)                              |
| kubectl-who-can               | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — shows which subjects have a given RBAC permission on a resource                                              |
| kubectl-access-matrix         | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — visualizes a subject's allowed actions across resources                                                      |
| kubectl-view-secret           | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — decodes a Secret's values without manual base64 decoding                                                     |
| kubectl-outdated              | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — flags resources using deprecated/removed API versions                                                        |
| kubectl-resource-capacity     | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — shows CPU/memory requests, limits, and utilization per node                                                  |
| kubectl-df-pv                 | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — shows disk usage of PersistentVolumes                                                                        |
| kubectl-node-shell            | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — drops into a root shell on a node via a temporary privileged pod                                             |
| kubectl-sniff                 | latest (krew)                                   | `ansible/roles/k8s`        | kubectl plugin (via krew) — captures pod network traffic with tcpdump/Wireshark without needing tcpdump in the container                 |
| loki                          | v3.7.3                                          | `ansible/roles/loki`       | Grafana Loki log aggregation system binary — receives, stores, and queries log streams (LogQL)                                           |
| tmux                          | latest (apt)                                    | `ansible/roles/tmux`       | Terminal multiplexer                                                                                                                     |
| Visual Studio Code            | latest (apt, via `gantsign.visual-studio-code`) | `ansible/roles/vscode`     | Source code editor (role not applied by the `platform` profile — see [VS Code](#vs-code-windows-side-for-remote-wsl-users))              |
| HashiCorp Terraform           | latest (`hashicorp.terraform`)                  | `ansible/roles/vscode`     | VS Code extension — Terraform syntax highlighting/autocompletion, and the configured `[terraform]` formatter (not applied by `platform`) |
| Terragrunt Language Server    | latest (`gruntwork.terragrunt-ls`)              | `ansible/roles/vscode`     | VS Code extension — official Gruntwork extension for Terragrunt HCL support (not applied by `platform`)                                  |
| GitLens                       | latest (`eamodio.gitlens`)                      | `ansible/roles/vscode`     | VS Code extension — git authorship/history visualization (not applied by `platform`)                                                     |
| YAML                          | latest (`redhat.vscode-yaml`)                   | `ansible/roles/vscode`     | VS Code extension — YAML language support, and the configured `[yaml]` formatter (not applied by `platform`)                             |

`ubuntu_basics` and `install_helper` install no tools of their own (`ubuntu_basics` only edits shell/sudo config; `install_helper` is a shared downloader used by `iac-tools`, `k8s`, and `loki` above) and so have no rows here.

## Repo layout

```
provision_environment.sh          # entry point
vars.yaml                         # user-specific variables
ansible/
  ansible.cfg                     # sets interpreter_python=auto_silent (silences interpreter-discovery warning)
  ansible_requirements.yaml       # galaxy roles/collections
  ansible_root_playbook.yaml      # imports the selected profile
  roles/                          # one directory per role (see table above)
                                   # each role has its own README.md — see docs/role-readme-guide.md
profiles/
  profile_platform.yaml           # role list for the "platform" profile
docs/
  role-readme-guide.md            # template/rules for writing a role's README.md
```

### VS Code (Windows side, for Remote-WSL users)

Install these extensions from the Extensions panel (VS Code will offer to install them "in WSL: \<distro\>" too when you're connected — decline that unless you actually need them server-side):

- `hashicorp.terraform`
- `gruntwork.terragrunt-ls`
- `eamodio.gitlens`
- `redhat.vscode-yaml`

And add to your Windows-side user settings (`Ctrl+Shift+P` → "Preferences: Open User Settings (JSON)"):

```json
{
  "redhat.telemetry.enabled": true,
  "editor.fontSize": 9,
  "editor.formatOnSave": false,
  "editor.renderWhitespace": "all",
  "files.insertFinalNewline": true,
  "files.associations": {
    "**/templates/*.yaml": "yaml",
    "**/templates/*.tpl": "yaml",
    "**/templates/**/*.yaml": "yaml",
    "**/templates/**/*.tpl": "yaml",
    "**/*.yaml.gotmpl": "yaml"
  },
  "[yaml]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "redhat.vscode-yaml"
  },
  "[helm]": {
    "editor.formatOnSave": true
  },
  "[terraform]": {
    "editor.defaultFormatter": "hashicorp.terraform",
    "editor.tabSize": 2
  },
  "[terraform-vars]": {
    "editor.tabSize": 2
  },
  "window.openFilesInNewWindow": "on",
  "workbench.editor.enablePreview": false,
  "explorer.confirmDragAndDrop": false,
  "explorer.confirmDelete": false,
  "security.allowedUNCHosts": ["wsl.localhost"],
  "remote.autoForwardPortsSource": "hybrid"
}
```
