# argo-cli-install
Installing the ArgoCD Operator using the CLI


## Setup Procedure

Ensure that the operator exists in the channel catalog.
```shell script
oc get packagemanifests -n openshift-marketplace | grep argo
```
Check the CSV information
```shell script
oc describe packagemanifests/argocd-operator -n openshift-marketplace | grep -A36 Channels
```

### Create a Project
```yaml
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    openshift.io/description: "ArgoCD project for gitops"
    openshift.io/display-name: "ArgoCD"
  name: argocd
```

### Create a Subscription
Create a Subscription object YAML file to subscribe a namespace to the ArgoCD Operator, for example, sub.yaml:

```yaml
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: argocd-operator
  namespace: argocd
spec:
  channel:  <channel name> #Specify the channel name from where you want to subscribe the Operator
  name: argocd-operator #Name of the Operator to subscribe to.
  source: community-operators #Name of the CatalogSource that provides the Operator.
  sourceNamespace: openshift-marketplace #Namespace of the CatalogSource. Use openshift-marketplace for the default OperatorHub CatalogSources.
```

```shell script
oc apply -f sub.yaml
```

---

## Create ArgoCD instance

To install one Argo CD instance we need to create a single ArgoCD CRD in the namespace of argocd (operator is watching this namesapce) to define all its properties and features.

```shell script
oc apply -n argocd -f instance/
```

### The basic ArgoCD manifest

**[argocd.yaml](argocd.yaml).**

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ArgoCD
metadata:
  name: argocd
  labels:
    target: argocd-application-delivery
spec:
....
```

### HA Deployment type

We are going to configure HA for Argo CD instance, refer to <https://argocd-operator.readthedocs.io/en/latest/usage/ha/>

**[argocd.yaml](argocd.yaml).**

```yaml
....
spec:
....
  ha:
    enabled: true
    redisProxyImage: haproxy
    redisProxyVersion: "2.0.4"
....
```

### Authentication

We are going to configure OpenShift OAuth server for authentication (based on Andrew Blog <https://www.openshift.com/blog/openshiftauthentication-integration-with-argocd>)

**[argocd.yaml](argocd.yaml).**

```yaml
...
spec:
  ....
  dex:
    image: quay.io/redhat-cop/dex
    version: v2.22.0-openshift
    openShiftOAuth: true
  ....
```

### RBAC

**[argocd.yaml](argocd.yaml).**

```yaml
...
spec:
  ....
  rbac:
    defaultPolicy: role:readonly
    policy: |
      g, argocdadmins, role:admin
      g, argocdusers, role:readonly
    scopes: "[groups]"
....
```

### Server Route Options

Configure the Route for the Argo CD Server component.

**[argocd.yaml](argocd.yaml).**

```yaml
...
spec:
  ....
  server:
    grpc:
      host: agrocd-grpc.<your domain name>
      ingress:
        enabled: true
    insecure: true
    host: agrocd.<your domain name>
    route:
      enabled: true
      tls:
        termination: edge
        insecureEdgeTerminationPolicy: Redirect
    ....
```

## Deploy the ArgoCD Instance

```shell script
    oc apply -k base/argocd
```