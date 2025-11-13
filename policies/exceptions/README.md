# Policy Exceptions

This directory contains PolicyException resources that allow specific resources to bypass certain Kyverno policy rules.

## Exceptions

### `legacy-root-exception.yml`

**Policy Name:** `allow-legacy-root`

**Type:** PolicyException (Kyverno v2)

**Purpose:** Provides an exception for legacy applications that need to run with privileged containers, allowing them to bypass the `disallow-privileged` rule from the `cis-rbi-baseline` policy.

**Exception Details:**

- **Target Policy:** `cis-rbi-baseline`
- **Target Rule:** `disallow-privileged`
- **Scope:** 
  - **Namespace:** `legacy`
  - **Resource Type:** Pod
  - **Resource Names:** Pods matching the pattern `old-app-*`
- **What it allows:** Pods in the `legacy` namespace with names starting with `old-app-` can run with `privileged: true` even though the baseline policy normally blocks this

**Why Use Exceptions:**

Policy exceptions are useful for:
- Gradual migration of legacy applications
- Temporary workarounds for applications that cannot be immediately updated
- Allowing specific, approved use cases that require privileged access
- Maintaining security posture while accommodating business requirements

**Best Practices:**

- Use exceptions sparingly and document the business justification
- Set expiration dates or review cycles for exceptions
- Scope exceptions as narrowly as possible (specific namespaces, names, labels)
- Regularly review and remove exceptions when no longer needed

## Testing

See `test-pod.yml` for test manifests that demonstrate how the exception works for legacy pods.

