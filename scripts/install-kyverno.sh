#!/bin/bash

helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update

helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace --set replicaCount=2

# NAME: kyverno
# LAST DEPLOYED: Thu Nov 13 11:52:33 2025
# NAMESPACE: kyverno
# STATUS: deployed
# REVISION: 1
# NOTES:
# Chart version: 3.6.0
# Kyverno version: v1.16.0

# Thank you for installing kyverno! Your release is named kyverno.

# The following components have been installed in your cluster:
# - CRDs
# - Admission controller
# - Reports controller
# - Cleanup controller
# - Background controller