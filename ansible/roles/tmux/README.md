# tmux

## General

Installs tmux, deploys the shared config from `files/tmux.conf` to `~/.config/tmux/tmux.conf` (always overwritten to match the repo — edit `files/tmux.conf`, not the deployed file, to make changes stick), and auto-attaches every new terminal to a `default` tmux session.

## What it installs

| Tool | Version      | Description          |
| ---- | ------------ | -------------------- |
| tmux | latest (apt) | Terminal multiplexer |
