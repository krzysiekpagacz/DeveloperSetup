# ubuntu_basics

## General

Doesn't install any packages. Configures passwordless `sudo` for the current user, adds a git-aware PS1 prompt to `.bashrc` — a green ✓/red ✗ for the last command's exit status, the current directory, the git branch when inside a repo, and (when `enable_k8s_prompt` is true) the current kubectl context:namespace in brackets, with GKE's `gke_<project>_<zone>_<cluster>` context names shortened to just `<cluster>` — exports `$EDITOR`/`$VISUAL` in `.bashrc` from the shared `default_editor` var, and writes a set of shell aliases (git/docker/k8s/terraform/tmux/helm shortcuts) to `.bash_aliases`.

## What it installs

N/A — this role only edits `/etc/sudoers`, `.bashrc`, and `.bash_aliases`; it installs no packages itself.
