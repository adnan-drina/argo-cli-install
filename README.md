# argo-cli-install
Installing the ArgoCD Operator using the CLI

## Setup Procedure
Ensure that the operator exists in the channel catalog.
```shell script
oc get packagemanifests -n openshift-marketplace | grep gitops
```
Check the CSV information
```shell script
oc describe packagemanifests/openshift-gitops-operator  -n openshift-marketplace
```

### Create a Project
[argocd-namespace.yaml](argocd-namespace.yaml)
```yaml
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    openshift.io/description: "Declarative GitOps CD for Kubernetes"
    openshift.io/display-name: "Argo CD"
  name: argocd
```
```shell script
oc apply -f argocd-namespace.yaml
```
or
```shell script
oc new-project argocd
```

### Create a Subscription
Create a Subscription object YAML file to subscribe a namespace to the ArgoCD Operator

[argocd-sub.yaml](argocd-sub.yaml)
```yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-gitops-operator
  namespace: openshift-operators
spec:
  channel: stable
  installPlanApproval: Automatic
  name: openshift-gitops-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
```

```shell script
oc apply -f argocd-sub.yaml
```