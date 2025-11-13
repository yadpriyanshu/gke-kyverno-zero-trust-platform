# Baseline Policies

This directory contains baseline security policies that enforce CIS (Center for Internet Security) and RBI (Runtime-Based Integrity) compliance standards.

## Policies

### `cis-rbi-enforce.yml`

**Policy Name:** `cis-rbi-baseline`

**Type:** ClusterPolicy (Validation)

**Purpose:** Enforces baseline security controls for Pods to meet CIS and RBI compliance requirements.

**Rules:**

1. **disallow-privileged**
   - **What it does:** Prevents Pods from running with privileged containers
   - **Why:** Privileged containers have access to host resources and can bypass security controls, increasing the attack surface
   - **Enforcement:** Blocks creation/update of Pods with `securityContext.privileged: true`

2. **require-readonly-fs**
   - **What it does:** Requires all containers to have a read-only root filesystem
   - **Why:** Prevents malicious processes from modifying the container filesystem, reducing the risk of persistence and tampering
   - **Enforcement:** Validates that all containers have `securityContext.readOnlyRootFilesystem: true`

**Validation Failure Action:** Enforce (blocks non-compliant resources)

**Background Mode:** Enabled (validates existing resources)

## Testing

See `test-pod.yml` for a test manifest that demonstrates both compliant and non-compliant Pod configurations.

