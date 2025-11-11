variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone for cluster"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "demo-gke-cluster"
}

variable "network_name" {
  description = "VPC network name (global)"
  type        = string
}

variable "subnetwork_name" {
  description = "Subnetwork name (regional)"
  type        = string
}

variable "pod_range_name" {
  description = "Secondary range for pods"
  type        = string
}

variable "svc_range_name" {
  description = "Secondary range for services"
  type        = string
}

variable "cluster_version" {
  description = "GKE master version"
  type        = string
  default     = "1.33.5-gke.1201000"
}

variable "release_channel" {
  description = "GKE release channel"
  type        = string
  default     = "REGULAR"
}

variable "enable_private_nodes" {
  description = "Enable private nodes"
  type        = bool
  default     = true
}

variable "master_ipv4_cidr" {
  description = "Master CIDR for private cluster"
  type        = string
  default     = "172.16.0.0/28"
}

variable "enable_private_endpoint" {
  description = "Use private endpoint only"
  type        = bool
  default     = false
}

variable "node_count" {
  description = "Number of nodes per zone"
  type        = number
  default     = 3
}

variable "machine_type" {
  description = "Node machine type"
  type        = string
  default     = "e2-standard-4"
}

variable "disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "pd-balanced"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 80
}

variable "image_type" {
  description = "Node image type"
  type        = string
  default     = "COS_CONTAINERD"
}

variable "enable_autoupgrade" {
  type    = bool
  default = true
}

variable "enable_autorepair" {
  type    = bool
  default = true
}

variable "max_surge" {
  type    = number
  default = 1
}

variable "max_unavailable" {
  type    = number
  default = 0
}

variable "enable_managed_prometheus" {
  type    = bool
  default = true
}

variable "workload_pool" {
  description = "Workload Identity pool"
  type        = string
}

variable "security_posture_mode" {
  type    = string
  default = "BASIC"
}

variable "enable_shielded_nodes" {
  type    = bool
  default = true
}

variable "enable_integrity_monitoring" {
  type    = bool
  default = true
}

variable "enable_secure_boot" {
  type    = bool
  default = false
}

variable "binauthz_mode" {
  type    = string
  default = "DISABLED"
}

variable "cluster_dns" {
  type    = string
  default = "CLOUD_DNS"
}

variable "cluster_dns_scope" {
  type    = string
  default = "CLUSTER_SCOPE"
}

variable "default_max_pods_per_node" {
  type    = number
  default = 110
}

variable "enable_intranode_visibility" {
  type    = bool
  default = false
}

variable "master_authorized_networks" {
  description = "List of CIDR blocks allowed to access master"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "monitoring_components" {
  description = "List of monitoring components to enable"
  type        = list(string)
  default = [
    "SYSTEM_COMPONENTS",
    "STORAGE",
    "POD",
    "DEPLOYMENT",
    "STATEFULSET",
    "DAEMONSET",
    "HPA",
    "JOBSET",
    "CADVISOR",
    "KUBELET",
    "DCGM"
  ]
}