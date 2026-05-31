variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_tag" {
  description = "Tag applied to all AWS resources via provider default_tags"
  type        = string
  default     = "karatu-2025-capstone"
}

variable "vpc_name" {
  description = "VPC name tag"
  type        = string
  default     = "project-bedrock-vpc"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "project-bedrock-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.34"
}

variable "azs" {
  description = "Availability Zones for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "node_instance_type" {
  description = "EKS managed node group instance type"
  type        = string
  default     = "t3.small"
}

variable "node_desired_size" {
  description = "EKS managed node group desired size"
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "EKS managed node group min size"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "EKS managed node group max size"
  type        = number
  default     = 2
}

variable "assets_bucket_name" {
  description = "S3 bucket name for application/static assets"
  type        = string
  default     = "bedrock-assets-alt-soe-025-3702"
}

variable "dynamodb_table_name" {
  description = "DynamoDB table name used by the retail app"
  type        = string
  default     = "Items"
}
