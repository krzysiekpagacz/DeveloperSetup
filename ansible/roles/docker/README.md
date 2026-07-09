# docker

## General

Installs Docker Engine (via the external `nickjj.docker` role) with custom bridge/address-pool daemon flags and the current user added to the `docker` group. Also removes legacy Docker apt repo/key artifacts, installs the Amazon ECR credential helper, and configures `~/.docker/config.json` (proxy settings and ECR credential store).

## What it installs

| Tool                         | Version                      | Description                                                                              |
| ---------------------------- | ---------------------------- | ---------------------------------------------------------------------------------------- |
| Docker Engine                | latest (via `nickjj.docker`) | Container runtime and CLI (`dockerd` + `docker`)                                         |
| Docker Compose v2            | latest (via `nickjj.docker`) | Multi-container orchestration plugin (`docker compose`)                                  |
| docker (Python SDK)          | 4.4.4                        | Python client library for the Docker Engine API, used by Ansible's docker-family modules |
| amazon-ecr-credential-helper | latest (apt)                 | Docker credential helper for authenticating to Amazon ECR                                |
