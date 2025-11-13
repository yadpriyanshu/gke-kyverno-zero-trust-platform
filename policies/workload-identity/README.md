# Workload Identity Policies

This directory contains policies that enforce Workload Identity Federation (WIF) and Google Service Account (GSA) usage patterns for secure authentication in GKE.

## Policies

### `restrict-wif-gsa.yml`

**Policy Name:** `restrict-workload-identity`

**Type:** ClusterPolicy (Validation)

**Purpose:** Enforces a specific naming convention for Google Service Accounts (GSA) used with Workload Identity Federation in GKE, ensuring only approved service accounts can be used.

**Rules:**

1. **enforce-gsa**
   - **What it does:** Validates that ServiceAccounts using Workload Identity must have a GCP service account annotation in a specific format
   - **Why:** Ensures consistent naming and prevents unauthorized service accounts from being used, maintaining security boundaries
   - **Required Format:** `prod-gsa@<project-id>.iam.gserviceaccount.com`
   - **Enforcement:** 
     - Validates the `iam.gke.io/gcp-service-account` annotation exists
     - Validates the annotation value matches the regex pattern: `^prod-gsa@[a-z0-9-]+\.iam\.gserviceaccount\.com$`
   - **Validation Method:** Uses CEL (Common Expression Language) for flexible validation

**Validation Failure Action:** Enforce (blocks non-compliant ServiceAccounts)

**Background Mode:** Disabled (validates only on create/update)

## Testing

See `test-serviceaccount.yml` for test manifests that demonstrate both compliant and non-compliant ServiceAccount configurations.

**Note:** Replace `<project-id>` in the test manifests with your actual GCP project ID.

