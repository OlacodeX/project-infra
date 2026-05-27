output "cluster_endpoint" {
  value = ""
}

output "cluster_name" {
  value = var.cluster_name
}

output "region" {
  value = var.aws_region
}

output "vpc_id" {
  value = module.vpc.vpc_id 
}

output "assets_bucket_name" {
  value = var.assets_bucket_name
}

