#!/bin/bash

#Make sure you're connected to your OpenShift cluster with admin user before running this script

echo "Creating Argo CD Subscription"
oc apply -f argocd-sub.yaml
echo "Argo CD Subscription created!"
