# vscode

## General

**Not applied by the `platform` profile on WSL.** If you use the standard Windows VS Code + Remote-WSL workflow, this role does nothing useful: VS Code itself, its settings, and its extensions all live outside this WSL filesystem — the actual editor and its user settings (`%APPDATA%\Code\User\settings.json`) are on the Windows side, and Remote-WSL's server-side extensions live under `~/.vscode-server` (created only after the first connection from Windows, so this repo can't pre-seed it). Install VS Code on Windows and add the Remote-WSL extension there instead; see this repo's README for the settings/extensions to add on the Windows side.

This role remains here for setups that actually run the Linux desktop VS Code inside WSL directly (e.g. via WSLg) or on a non-WSL Ubuntu machine. In that case it installs VS Code (desktop) via the external `gantsign.visual-studio-code` role, removes the legacy Microsoft apt repo, installs the extensions listed in `vscode_extensions` via `code --install-extension` (with `DONT_PROMPT_WSL_INSTALL=1`, since the `code` CLI refuses to run non-interactively under WSL otherwise), and writes baseline user settings to `~/.config/Code/User/settings.json` (creating that directory first, since a fresh VS Code install doesn't create it until first launch).

## What it installs

| Tool                       | Version                                         | Description                                                                               |
| -------------------------- | ----------------------------------------------- | ----------------------------------------------------------------------------------------- |
| Visual Studio Code         | latest (apt, via `gantsign.visual-studio-code`) | Source code editor                                                                        |
| HashiCorp Terraform        | latest (`hashicorp.terraform`)                  | Terraform syntax highlighting/autocompletion; also the configured `[terraform]` formatter |
| Terragrunt Language Server | latest (`gruntwork.terragrunt-ls`)              | Official Gruntwork extension for Terragrunt HCL support                                   |
| GitLens                    | latest (`eamodio.gitlens`)                      | Git authorship/history visualization                                                      |
| YAML                       | latest (`redhat.vscode-yaml`)                   | YAML language support; also the configured `[yaml]` formatter                             |
