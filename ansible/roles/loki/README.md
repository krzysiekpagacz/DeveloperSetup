# loki

## General

Installs the Grafana Loki binary (`loki-linux-amd64.zip` from the GitHub releases page) via `install_helper`, verifies the download checksum against the upstream `SHA256SUMS` file, and registers `loki` as a global command in `/usr/local/bin`. Requires `become: true` (handled by `install_helper`).

## What it installs

| Tool   | Version | Description                                                                                     |
| ------ | ------- | ----------------------------------------------------------------------------------------------- |
| `loki` | v3.7.3  | Grafana Loki log aggregation system binary — receives, stores, and queries log streams (LogQL) |
