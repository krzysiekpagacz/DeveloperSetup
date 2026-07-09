# k8s

## General

Installs kubectl and core Kubernetes tooling (k9s, Helm + plugins, kubectx/kubens), plus krew (the kubectl plugin manager) with a curated set of kubectl plugins. Also enables kubectl bash completion and creates `~/.kube`.

## What it installs

| Tool                      | Version       | Description                                                                                  |
| ------------------------- | ------------- | -------------------------------------------------------------------------------------------- |
| kubectl                   | v1.34.0       | Kubernetes command-line client                                                               |
| k9s                       | v0.50.13      | Terminal UI for managing Kubernetes clusters                                                 |
| Helm                      | latest (snap) | Kubernetes package manager                                                                   |
| helm-git                  | 0.15.1        | Helm plugin to use git repos as chart sources                                                |
| helm-secrets              | 4.6.5         | Helm plugin for encrypting/decrypting secret values files                                    |
| kubectx                   | v0.9.5        | Fast Kubernetes context switcher                                                             |
| kubens                    | v0.9.5        | Fast Kubernetes namespace switcher                                                           |
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
