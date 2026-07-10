# install_helper

## General

Not applied directly by any profile. This is a shared utility role, included via `include_role` by other roles (currently `iac-tools` and `k8s`), that downloads a release archive/binary from a URL, optionally verifies a checksum (with a special-cased lookup for internal Nexus-hosted assets), unpacks it if needed, and symlinks the resulting executable(s) into `/usr/local/bin`. Behavior is driven entirely by the `install_helper_*` variables passed in by the including role. The download itself retries up to 3 times (10s apart) to tolerate transient network timeouts on large release assets.

## What it installs

N/A — installs whatever the including role configures via `install_helper_download_url`/`install_helper_install_folder`/`install_helper_register_commands`. See the consuming role's own README (e.g. `iac-tools`, `k8s`) for the specific tool and version installed.
