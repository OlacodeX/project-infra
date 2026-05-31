locals {
  # Observability is enabled via module.eks.cluster_addons in eks.tf
  # and control-plane logging via module.eks.cluster_enabled_log_types.
  control_plane_log_group_prefix  = "/aws/eks/${var.cluster_name}/cluster"
  container_logs_log_group_prefix = "/aws/containerinsights/${var.cluster_name}"
}
