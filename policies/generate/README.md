# Generate Policies

This directory contains Kyverno policies that automatically generate Kubernetes resources when certain conditions are met.

## Policies

### `auto-quota-netpol.yml`

**Policy Name:** `auto-quota-netpol`

**Type:** ClusterPolicy (Generation)

**Purpose:** Automatically creates ResourceQuota and NetworkPolicy resources for new namespaces, ensuring consistent resource limits and network isolation across all namespaces.

**Rules:**

1. **generate-quota**
   - **What it does:** Automatically generates a ResourceQuota named `default-quota` when a new Namespace is created
   - **Why:** Ensures all namespaces have resource limits, preventing resource exhaustion and enabling better cluster resource management
   - **Generated ResourceQuota Limits:**
     - Pods: `30`
     - CPU requests: `8` cores
     - Memory requests: `16Gi`
   - **Exclusions:** Does not generate quotas for system namespaces:
     - `kube-system`
     - `kyverno`
     - `argocd`
   - **Synchronization:** Enabled (quota is kept in sync with namespace lifecycle)

2. **generate-netpol**
   - **What it does:** Automatically generates a NetworkPolicy named `default-deny` when a new Namespace is created
   - **Why:** Implements a default-deny network policy, ensuring all network traffic is blocked by default and must be explicitly allowed
   - **Generated NetworkPolicy:**
     - Applies to all pods in the namespace (empty podSelector)
     - Blocks all ingress and egress traffic by default
   - **Synchronization:** Enabled (network policy is kept in sync with namespace lifecycle)

**Validation Failure Action:** Not applicable (generation policies don't validate)

**Background Mode:** Not applicable

## Testing

See `test-namespace.yml` for a test manifest that demonstrates how the policy automatically generates ResourceQuota and NetworkPolicy resources when a namespace is created.

