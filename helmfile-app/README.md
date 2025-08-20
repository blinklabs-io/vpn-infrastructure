# HELMFILE APP

Helmfile_app is a directory that contains a helmfile.yaml and multiple template layers
to deploy a helm charts with helmfile.
It supports vpn type clusters with future support for other types of clusters.
It supports multiple environment per cluster type.

## Prerequisites

- [Helm](https://helm.sh/docs/intro/install/) installed
- [Helmfile](https://github.com/helmfile/helmfile) installed
- helmfile diff plugin `helm plugin install https://github.com/databus23/helm-diff`
- [kubectl](https://kubernetes.io/docs/tasks/tools/) installed

## Manual usage

1. Clone the repository
2. Change directory to helmfile-app

###

Important pick the right kubernetes context before running the helm commands

```bash
# Set the kubernetes context
kubectl config use-context <context-name>
```

```bash
# Template the helmfile
helmfile -e aws-vpn -l app=kube-state-metrics template

# Template the helmfile with debug
helmfile -e aws-vpn -l app=kube-state-metrics template --debug

# Check difference between the current state and the desired state
helmfile diff -e aws-vpn -l app=kube-state-metrics

# Apply the helmfile
helmfile -e aws-vpn -l app=kube-state-metrics apply

# Delete the helmfile
helmfile -e aws-vpn -l app=kube-state-metrics destroy
```
