# cli_utils

## General

Installs a base set of common CLI utilities via apt that everyday shell use and other roles rely on (e.g. `sponge` from `moreutils` is used by the `docker` role).

## What it installs

| Tool                | Version      | Description                                                                  |
| ------------------- | ------------ | ---------------------------------------------------------------------------- |
| apt-transport-https | latest (apt) | HTTPS transport for apt package management                                   |
| bash-completion     | latest (apt) | Programmable tab-completion for bash                                         |
| coreutils           | latest (apt) | GNU core utilities (`ls`, `cat`, etc.)                                       |
| curl                | latest (apt) | Command-line HTTP/file transfer client                                       |
| gnupg               | latest (apt) | GPG encryption/signing toolkit, used for apt repo keys                       |
| graphviz            | latest (apt) | Graph visualization tools (e.g. `dot`), used by tools like `terraform graph` |
| htop                | latest (apt) | Interactive process/resource viewer                                          |
| jq                  | latest (apt) | Command-line JSON processor                                                  |
| lsb-release         | latest (apt) | Reports Linux Standard Base / distribution info                              |
| moreutils           | latest (apt) | Extra Unix utilities, including `sponge`                                     |
| python3-pip         | latest (apt) | Python 3 package installer                                                   |
| ssh                 | latest (apt) | OpenSSH client/server                                                        |
| tar                 | latest (apt) | Archive utility                                                              |
| unzip               | latest (apt) | Zip archive extractor                                                        |
| wget                | latest (apt) | Command-line file downloader                                                 |
| vim                 | latest (apt) | Text editor (also configured as the default git editor)                      |
| yq                  | latest (apt) | Command-line YAML processor                                                  |
