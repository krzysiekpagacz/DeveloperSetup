# ubuntu_basics

## General

Doesn't install any packages. Configures passwordless `sudo` for the current user, adds a git-aware PS1 prompt (optionally showing the current kubectl context, via `enable_k8s_prompt`) to `.bashrc`, and writes a set of shell aliases (git/docker/k8s/terraform/tmux/helm shortcuts) to `.bash_aliases`.

## What it installs

N/A — this role only edits `/etc/sudoers`, `.bashrc`, and `.bash_aliases`; it installs no packages itself.
