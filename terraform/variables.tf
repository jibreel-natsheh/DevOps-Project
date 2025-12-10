variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "ecommerce"
}

variable "environment" {
  description = "The environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "West US"
}

variable "kubernetes_version" {
  description = "The Kubernetes version for AKS"
  type        = string
  default     = "1.30"
}

variable "node_count" {
  description = "The initial number of nodes in the AKS cluster"
  type        = number
  default     = 1
}

variable "node_vm_size" {
  description = "The VM size for AKS nodes"
  type        = string
  default     = "Standard_DC2s_v3"
}

variable "min_node_count" {
  description = "Minimum number of nodes for autoscaling"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes for autoscaling"
  type        = number
  default     = 3
}

variable "acr_sku" {
  description = "The SKU for Azure Container Registry"
  type        = string
  default     = "Standard"
}

variable "postgres_sku" {
  description = "The SKU for Azure PostgreSQL"
  type        = string
  default     = "B_Gen5_1"
}

variable "postgres_storage_mb" {
  description = "Storage size for PostgreSQL in MB"
  type        = number
  default     = 51200
}

variable "postgres_admin_username" {
  description = "Administrator username for PostgreSQL"
  type        = string
  default     = "psqladmin"
}

variable "postgres_admin_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "redis_capacity" {
  description = "The size of the Redis cache"
  type        = number
  default     = 1
}

variable "redis_family" {
  description = "The SKU family for Redis cache"
  type        = string
  default     = "C"
}

variable "redis_sku_name" {
  description = "The SKU name for Redis cache"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "E-commerce"
    ManagedBy   = "Terraform"
    Environment = "Production"
  }
}
