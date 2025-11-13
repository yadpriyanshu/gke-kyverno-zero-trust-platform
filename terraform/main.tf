resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  project  = var.project_id
  location = var.zone

  initial_node_count       = 1
  remove_default_node_pool = true

  min_master_version = var.cluster_version

  deletion_protection = false

  lifecycle {
    ignore_changes = [
      node_pool,
      initial_node_count
    ]
  }

  release_channel {
    channel = var.release_channel
  }

  network    = "projects/${var.project_id}/global/networks/${var.network_name}"
  subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/${var.subnetwork_name}"

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_range_name
    services_secondary_range_name = var.svc_range_name
  }

  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr
  }

  dns_config {
    cluster_dns       = var.cluster_dns
    cluster_dns_scope = var.cluster_dns_scope
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  monitoring_config {
    enable_components = var.monitoring_components
    managed_prometheus {
      enabled = var.enable_managed_prometheus
    }
  }

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "APISERVER", "CONTROLLER_MANAGER", "SCHEDULER", "WORKLOADS"]
  }

  workload_identity_config {
    workload_pool = var.workload_pool
  }

  security_posture_config {
    mode = var.security_posture_mode
  }

  enable_shielded_nodes = var.enable_shielded_nodes

  binary_authorization {
    evaluation_mode = var.binauthz_mode
  }

  default_max_pods_per_node   = var.default_max_pods_per_node
  enable_intranode_visibility = var.enable_intranode_visibility

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block = cidr_blocks.value
      }
    }
  }

  node_config {
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [google_container_cluster.primary]
  create_duration = "30s"
}

resource "google_container_node_pool" "primary" {
  name       = "${var.cluster_name}-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.node_count

  depends_on = [time_sleep.wait_30_seconds]

  node_config {
    machine_type = var.machine_type
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb
    image_type   = var.image_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    shielded_instance_config {
      enable_integrity_monitoring = var.enable_integrity_monitoring
      enable_secure_boot          = var.enable_secure_boot
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  management {
    auto_repair  = var.enable_autorepair
    auto_upgrade = var.enable_autoupgrade
  }

  upgrade_settings {
    max_surge       = var.max_surge
    max_unavailable = var.max_unavailable
  }
}