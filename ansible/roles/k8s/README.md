# k8s

## General

Installs kubectl and core Kubernetes tooling (k9s, Helm + plugins, kubectx/kubens), plus krew (the kubectl plugin manager) with a curated set of kubectl plugins. Also enables kubectl bash completion and creates `~/.kube`. The `helm-git`/`helm-secrets` plugin installs pass `verify: false` since Helm v4 requires plugin signature verification by default, which VCS/git-based plugin sources (as opposed to signed tarballs) don't support — this requires `kubernetes.core` >= 6.4.0 (pinned in `ansible/ansible_requirements.yaml`) for the `verify` parameter to exist.

## What it installs

| Tool                      | Version       | Description                                                                                  |
| ------------------------- | ------------- | -------------------------------------------------------------------------------------------- |
| kubectl                   | v1.36.2       | Kubernetes command-line client                                                               |
| k9s                       | v0.51.0       | Terminal UI for managing Kubernetes clusters                                                 |
| Helm                      | latest (snap) | Kubernetes package manager                                                                   |
| helm-git                  | v1.5.2        | Helm plugin to use git repos as chart sources                                                |
| helm-secrets              | v4.7.7        | Helm plugin for encrypting/decrypting secret values files                                    |
| kubectx                   | v0.11.0       | Fast Kubernetes context switcher                                                             |
| kubens                    | v0.11.0       | Fast Kubernetes namespace switcher                                                           |
| krew                      | v0.5.0        | Plugin manager for kubectl                                                                   |
| kubectl-ktop              | latest (krew) | Real-time CPU/memory usage per pod/node, like `top` for Kubernetes                           |
| kubectl-stern             | latest (krew) | Tail logs from multiple pods/containers with color-coded, filterable output                  |
| kubectl-neat              | latest (krew) | Cleans `kubectl get -o yaml` output of managed fields/status noise                           |
| kubectl-tree              | latest (krew) | Shows the ownership hierarchy of resources (e.g. Deployment → ReplicaSet → Pod)              |
| kubectl-who-can           | latest (krew) | Shows which subjects have a given RBAC permission on a resource                              |
| kubectl-access-matrix     | latest (krew) | Visualizes a subject's allowed actions across resources                                      |
| kubectl-view-secret       | latest (krew) | Decodes a Secret's values without manual base64 decoding                                     |
| kubectl-outdated          | latest (krew) | Flags resources using deprecated/removed API versions                                        |
| kubectl-resource-capacity | latest (krew) | Shows CPU/memory requests, limits, and utilization per node                                  |
| kubectl-df-pv             | latest (krew) | Shows disk usage of PersistentVolumes                                                        |
| kubectl-node-shell        | latest (krew) | Drops into a root shell on a node via a temporary privileged pod                             |
| kubectl-sniff             | latest (krew) | Captures pod network traffic with tcpdump/Wireshark without needing tcpdump in the container |
