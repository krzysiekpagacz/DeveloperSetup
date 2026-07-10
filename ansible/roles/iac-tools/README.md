# iac-tools

## General

Installs version-manager tools for Terraform and Terragrunt (`tfswitch`/`tgswitch`, via the `install_helper` role) and uses them to install pinned Terraform/Terragrunt versions. Also installs `tflint`, sets up a shared Terraform provider plugin cache, and adds related PATH/alias/ulimit tweaks to `.bashrc`.

## What it installs

| Tool                          | Version | Description                                                                        |
| ----------------------------- | ------- | ---------------------------------------------------------------------------------- |
| tgswitch                      | 0.6.0   | Version manager/switcher for Terragrunt                                            |
| terragrunt                    | v1.1.0  | Thin wrapper for Terraform for keeping configurations DRY (installed via tgswitch) |
| tfswitch (terraform-switcher) | v1.19.0 | Version manager/switcher for Terraform                                             |
| terraform                     | 1.15.8  | Infrastructure-as-code provisioning tool (installed via tfswitch)                  |
| tflint                        | v0.63.1 | Terraform linter for detecting errors and enforcing best practices                 |
