# GKE Kyverno Zero-Trust Platform

A production-grade **Zero-Trust Kubernetes platform** built on **Google Kubernetes Engine (GKE)** with **Kyverno** policy engine enforcing comprehensive security controls, compliance standards, and best practices.

## 🎯 Overview

This platform implements a complete Zero-Trust security model for Kubernetes, combining:
- **Infrastructure as Code** (Terraform) for secure GKE cluster provisioning
- **Policy as Code** (Kyverno) for runtime security enforcement
- **GitOps** (ArgoCD) for automated policy and application deployment
- **Workload Identity** enforcement for secure GCP service account usage
- **Automated resource management** with auto-generated quotas and network policies

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    GKE Cluster (Private)                    │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Kyverno Policy Engine                    │  │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐            │  │
│  │  │ Baseline │ │  Mutate  │ │ Generate │            │  │
│  │  │ Policies │ │ Policies │ │ Policies │            │  │
│  │  └──────────┘ └──────────┘ └──────────┘            │  │
│  │  ┌──────────┐ ┌──────────┐                         │  │
│  │  │  WIF     │ │Exception │                         │  │
│  │  │ Policies │ │ Policies │                         │  │
│  │  └──────────┘ └──────────┘                         │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              ArgoCD (GitOps Controller)              │  │
│  │         Syncs policies from Git repository           │  │
│  └──────────────────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         Workloads (Pods, Deployments, etc.)          │  │
│  │    Enforced by Kyverno admission webhooks            │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Repository Structure

```
gke-kyverno-zero-trust-platform/
├── terraform/              # Infrastructure as Code
│   ├── main.tf             # GKE cluster configuration
│   ├── variables.tf        # Terraform variables
│   ├── outputs.tf          # Cluster outputs
│   ├── provider.tf         # GCP provider configuration
│   └── terraform.tfvars    # Variable values
│
├── policies/               # Kyverno policies (Policy as Code)
│   ├── baseline/           # CIS/RBI compliance policies
│   │   ├── cis-rbi-enforce.yml
│   │   ├── README.md
│   │   └── test-pod.yml
│   │
│   ├── mutate/             # Mutation policies
│   │   ├── default-resources.yml
│   │   ├── README.md
│   │   └── test-pod.yml
│   │
│   ├── generate/           # Generation policies
│   │   ├── auto-quota-netpol.yml
│   │   ├── README.md
│   │   └── test-namespace.yml
│   │
│   ├── workload-identity/  # Workload Identity policies
│   │   ├── restrict-wif-gsa.yml
│   │   ├── README.md
│   │   └── test-serviceaccount.yml
│   │
│   └── exceptions/          # Policy exceptions
│       ├── legacy-root-exception.yml
│       ├── README.md
│       └── test-pod.yml
│
├── scripts/                # Installation scripts
│   ├── install-kyverno.sh  # Kyverno installation
│   └── install-argo.sh     # ArgoCD installation
│
├── argocd/                 # GitOps configuration
│   └── app-of-apps.yaml    # ArgoCD application definition
│
├── manifests/              # Example/test manifests
│   ├── good-pod-signed.yml # Compliant pod example
│   ├── bad-pod-unsigned.yml# Non-compliant pod example
│   └── legacy-app.yml      # Legacy app example
│
└── README.md               # This file
```

## 🔒 Security Features

### 1. Baseline Security Policies (`policies/baseline/`)
- **Disallow Privileged Containers**: Prevents pods from running with privileged access
- **Require Read-Only Root Filesystem**: Enforces immutable container filesystems
- **CIS/RBI Compliance**: Meets Center for Internet Security and Runtime-Based Integrity standards

### 2. Resource Management (`policies/mutate/`)
- **Default Resource Limits**: Automatically adds CPU and memory limits/requests to pods
- **Prevents Resource Exhaustion**: Ensures fair resource allocation across workloads

### 3. Automated Resource Generation (`policies/generate/`)
- **Auto ResourceQuota**: Creates resource quotas for new namespaces (30 pods, 8 CPU, 16Gi memory)
- **Auto NetworkPolicy**: Generates default-deny network policies for network isolation
- **Zero-Trust Networking**: All traffic blocked by default, must be explicitly allowed

### 4. Workload Identity Enforcement (`policies/workload-identity/`)
- **GCP Service Account Validation**: Enforces specific naming convention for Workload Identity
- **Format**: `prod-gsa@<project-id>.iam.gserviceaccount.com`
- **Prevents Unauthorized Access**: Only approved service accounts can be used

### 5. Policy Exceptions (`policies/exceptions/`)
- **Legacy Application Support**: Allows exceptions for legacy apps that cannot be immediately updated
- **Scoped Exceptions**: Narrowly scoped to specific namespaces and resource names
- **Gradual Migration**: Enables phased security improvements

## 🚀 Quick Start

### Prerequisites

- GCP account with billing enabled
- `gcloud` CLI installed and configured
- `kubectl` installed
- `terraform` >= 1.0 installed
- `helm` installed (for Kyverno)
- Access to create GKE clusters and required GCP resources

### Step 1: Configure Terraform Variables

Edit `terraform/terraform.tfvars` with your GCP project details:

```hcl
project_id        = "your-gcp-project-id"
region            = "us-central1"
zone              = "us-central1-a"
cluster_name      = "demo-gke-cluster"
network_name      = "your-vpc-network"
subnetwork_name   = "your-subnet"
pod_range_name    = "your-pod-range"
svc_range_name    = "your-svc-range"
workload_pool     = "your-project-id.svc.id.goog"
```

### Step 2: Provision GKE Cluster

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

This creates a secure GKE cluster with:
- Private nodes and endpoint
- Workload Identity enabled
- Shielded nodes with integrity monitoring
- Managed Prometheus monitoring
- Binary Authorization (configurable)

### Step 3: Configure kubectl

```bash
gcloud container clusters get-credentials <cluster-name> --zone <zone> --project <project-id>
```

### Step 4: Install Kyverno

```bash
./scripts/install-kyverno.sh
```

This installs Kyverno v1.16.0 with:
- Admission controller
- Reports controller
- Background controller
- Cleanup controller

### Step 5: Install ArgoCD

```bash
./scripts/install-argo.sh
```

This installs ArgoCD and configures it with a LoadBalancer service.

### Step 6: Configure ArgoCD GitOps

```bash
kubectl apply -f argocd/app-of-apps.yaml
```

This sets up ArgoCD to automatically sync policies from the Git repository.

### Step 7: Access ArgoCD UI

Get the ArgoCD admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Get the LoadBalancer external IP:
```bash
kubectl get svc argocd-server -n argocd
```

Access the ArgoCD UI at: `https://<EXTERNAL-IP>` (username: `admin`, password from above)

## 📋 Policy Documentation

Each policy directory contains detailed documentation:

- **`policies/baseline/README.md`** - CIS/RBI compliance policies
- **`policies/mutate/README.md`** - Resource mutation policies
- **`policies/generate/README.md`** - Resource generation policies
- **`policies/workload-identity/README.md`** - Workload Identity policies
- **`policies/exceptions/README.md`** - Policy exception documentation

Each directory also includes test manifests demonstrating policy behavior.

## 🧪 Testing Policies

### Test Baseline Policies

```bash
# Test compliant pod
kubectl apply -f policies/baseline/test-pod.yml

# Verify non-compliant pods are blocked
kubectl apply -f manifests/bad-pod-unsigned.yml
# Note: This will be blocked if it violates baseline policies
```

### Test Workload Identity

```bash
# Test ServiceAccount with proper format
kubectl apply -f policies/workload-identity/test-serviceaccount.yml
```

### Test Resource Generation

```bash
# Create namespace and verify auto-generated resources
kubectl apply -f policies/generate/test-namespace.yml
kubectl get resourcequota -n test-namespace
kubectl get networkpolicy -n test-namespace
```

### Test Policy Exceptions

```bash
# Create legacy namespace and test exception
kubectl create namespace legacy
kubectl apply -f policies/exceptions/test-pod.yml
```

## 🔄 GitOps Workflow

1. **Policy Changes**: Update policies in the `policies/` directory
2. **Git Commit**: Commit and push changes to the repository
3. **ArgoCD Sync**: ArgoCD automatically detects changes and syncs policies
4. **Kyverno Enforcement**: Updated policies are immediately enforced

The `argocd/app-of-apps.yaml` configuration:
- Monitors the `policies/` directory recursively
- Syncs to the `kyverno` namespace
- Enables automated sync with pruning and self-healing

## 🛡️ Security Best Practices

1. **Private Cluster**: Cluster nodes and endpoint are private by default
2. **Workload Identity**: Use Workload Identity instead of service account keys
3. **Network Isolation**: Default-deny network policies on all namespaces
4. **Resource Limits**: All pods have resource limits to prevent DoS
5. **Read-Only Filesystems**: Containers run with immutable filesystems
6. **No Privileged Containers**: Privileged access is blocked by default

## 📊 Monitoring and Reporting

- **Kyverno Reports**: Use `PolicyReport` and `ClusterPolicyReport` resources
- **PolicyReporter UI**: Access policy violation reports via PolicyReporter dashboard
- **GKE Monitoring**: Integrated with Google Cloud Monitoring and Prometheus

## 🔧 Customization

### Adjust Resource Quotas

Edit `policies/generate/auto-quota-netpol.yml` to modify default quotas:
```yaml
hard:
  pods: "30"
  requests.cpu: "8"
  requests.memory: "16Gi"
```

### Modify Workload Identity Format

Edit `policies/workload-identity/restrict-wif-gsa.yml` to change the required format.

### Add Policy Exceptions

Create new exception files in `policies/exceptions/` following the pattern in `legacy-root-exception.yml`.

## 🐛 Troubleshooting

### Policy Not Enforcing

1. Check Kyverno pods are running:
   ```bash
   kubectl get pods -n kyverno
   ```

2. Check policy status:
   ```bash
   kubectl get clusterpolicies
   ```

3. Review Kyverno logs:
   ```bash
   kubectl logs -n kyverno -l app.kubernetes.io/name=kyverno
   ```

### ArgoCD Not Syncing

1. Check ArgoCD application status:
   ```bash
   kubectl get applications -n argocd
   ```

2. Review ArgoCD logs:
   ```bash
   kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server
   ```

3. Check LoadBalancer service status:
   ```bash
   kubectl get svc argocd-server -n argocd
   ```

## 📚 Additional Resources

- [Kyverno Documentation](https://kyverno.io/docs/)
- [GKE Security Best Practices](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)

## 👤 Author

**@yadpriyanshu** | November 2025

## 📝 License

This project is provided as-is for educational and production use.

---

**Note**: This is a production-ready platform template. Customize variables, policies, and configurations according to your organization's security requirements and compliance needs.
