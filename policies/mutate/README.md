# Mutation Policies

This directory contains Kyverno policies that automatically mutate (modify) resources to add default configurations.

## Policies

### `default-resources.yml`

**Policy Name:** `default-resources`

**Type:** ClusterPolicy (Mutation)

**Purpose:** Automatically adds default resource limits and requests to Pods that don't specify them, ensuring proper resource management and preventing resource exhaustion.

**Rules:**

1. **add-defaults**
   - **What it does:** Mutates Pods to add default CPU and memory resource limits and requests
   - **Why:** Ensures all Pods have resource constraints, preventing resource starvation and enabling better cluster resource management
   - **Default Values Added:**
     - **Limits:**
       - CPU: `500m` (0.5 cores)
       - Memory: `512Mi`
     - **Requests:**
       - CPU: `250m` (0.25 cores)
       - Memory: `256Mi`
   - **Behavior:** Uses strategic merge patch to add resources only if not already specified

**Validation Failure Action:** Enforce

**Background Mode:** Enabled (mutates existing resources)

## Testing

See `test-pod.yml` for a test manifest that demonstrates how the policy mutates Pods without resource specifications.

