#!/bin/bash

#Make sure you're connected to your OpenShift cluster with admin user before running this script

echo "Creating Argo CD namespace"
oc apply -f argocd-namespace.yaml
echo "Argo CD namespace created!"
echo " "
echo "Creating Argo CD OperatorGroup"
oc apply -f argocd-og.yaml
echo "Argo CD OperatorGroup created!"
echo " "
echo "Creating Argo CD config"
oc apply -f instance/argocd-groups.yaml
oc apply -f instance/argocd-scc.yaml
oc apply -f instance/cluster-role-binding.yaml
oc apply -f instance/gpg-keys-cm.yaml
echo "Argo CD config created!"
echo " "
echo "Creating Argo CD Subscription"
oc apply -f argocd-sub.yaml
ARGO="$(oc get pods -o name -n argocd | grep argocd-operator-)"
oc -n argocd wait --for=condition=Ready ${ARGO}
echo "Argo CD Subscription created!"
echo " "
echo "Deploying Argo CD CR"
HOSTNAME=$(oc config view --minify -o jsonpath='{.clusters[*].cluster.server}' | rev | cut -d':' -f2 | rev | cut -b 6-)
sed -i -e "s|.cluster-dd79.dd79.example.opentlc.com|$HOSTNAME|g" instance/argocd.yaml
oc apply -f instance/argocd.yaml
echo "Argo CD CR created!"
#echo " "
#echo "Searching for available routes"
#oc get routes -n argocd
#echo "connect to the route named argocd using your browser \
#and login using your openshift credentials"
