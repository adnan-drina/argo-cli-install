# GitOps Service Operator
A web service for rendering the GitOps UI on OpenShift

## Setup Procedure
Ensure that the operator exists in the channel catalog.
```shell script
oc get packagemanifests -n openshift-marketplace | grep gitops
```

Query the available channels for GitOps operator
```shell script
oc get packagemanifest -o jsonpath='{range .status.channels[*]}{.name}{"\n"}{end}{"\n"}' -n openshift-marketplace gitops-operator
```

Discover whether the operator can be installed cluster-wide or in a single namespace
```shell script
oc get packagemanifest -o jsonpath='{range .status.channels[*]}{.name}{" => cluster-wide: "}{.currentCSVDesc.installModes[?(@.type=="AllNamespaces")].supported}{"\n"}{end}{"\n"}' -n openshift-marketplace gitops-operator
```

Check the CSV information
```shell script
oc describe packagemanifests/gitops-operator -n openshift-marketplace | grep -A36 Channels
```
