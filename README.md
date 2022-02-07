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