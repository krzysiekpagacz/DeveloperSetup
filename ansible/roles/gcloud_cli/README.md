# gcloud_cli

## General

Removes the legacy `google-cloud-sdk.list`/keyring left behind by this role's old `apt_key`+`apt_repository` tasks (a stale `.list` file conflicts with the new `deb822_repository`-managed `.sources` file on `Signed-By`, which makes `apt` refuse to read _any_ sources at all — not just this repo's), then adds the Google Cloud apt repository (with its signing key) via `deb822_repository` (auto-installs its `python3-debian` dependency) and installs the Google Cloud CLI, then verifies the installation by printing its version.

## What it installs

| Tool             | Version      | Description                                                |
| ---------------- | ------------ | ---------------------------------------------------------- |
| google-cloud-cli | latest (apt) | Google Cloud SDK CLI (`gcloud`) for managing GCP resources |
