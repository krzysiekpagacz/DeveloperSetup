# docker

## General

Installs Docker Engine (via the external `nickjj.docker` role, pinned in `ansible/ansible_requirements.yaml` — must be >= v2.5.2, since earlier versions use a conditional incompatible with newer strict ansible-core) with custom bridge/address-pool daemon flags and the current user added to the `docker` group. Before `nickjj.docker` runs, this role removes legacy Docker apt source files (`download_docker_com_linux_ubuntu.list`, `docker.list`, and apt-created `archive_uri-...` list files) so duplicate entries for `https://download.docker.com/linux/ubuntu` cannot conflict on `Signed-By` (`/etc/apt/keyrings/docker.gpg` vs `/etc/apt/keyrings/docker.asc`). It also removes the legacy apt-key (via a raw `apt-key del` command rather than the deprecated `apt_key` module, since there's no `deb822_repository`-style replacement for removing a single key from the legacy system keyring), installs the Amazon ECR credential helper, and configures `~/.docker/config.json` (proxy settings and ECR credential store).

Note: `nickjj.docker` v2.5.3 (the latest available release) still uses the deprecated `apt_repository` module and un-namespaced facts internally, which surfaces a few deprecation warnings from ansible-core >= 2.21 during a run. This is upstream's code, not ours — nothing to fix here until they release a newer version.

## What it installs

| Tool                         | Version                      | Description                                                                              |
| ---------------------------- | ---------------------------- | ---------------------------------------------------------------------------------------- |
| Docker Engine                | latest (via `nickjj.docker`) | Container runtime and CLI (`dockerd` + `docker`)                                         |
| Docker Compose v2            | latest (via `nickjj.docker`) | Multi-container orchestration plugin (`docker compose`)                                  |
| docker (Python SDK)          | 4.4.4                        | Python client library for the Docker Engine API, used by Ansible's docker-family modules |
| amazon-ecr-credential-helper | latest (apt)                 | Docker credential helper for authenticating to Amazon ECR                                |
