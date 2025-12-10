# Random suffix for globally unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Azure Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

# Virtual Network for AKS
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-${var.environment}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

# Subnet for AKS
resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = "${var.project_name}${var.environment}acr${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.acr_sku
  admin_enabled       = true
  tags                = var.tags
}

# Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-${var.environment}-aks"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${var.project_name}-${var.environment}"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.node_vm_size
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
    enable_auto_scaling = true
    min_count           = var.min_node_count
    max_count           = var.max_node_count
    os_disk_size_gb     = 30
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    network_policy    = "azure"
  }

  tags = var.tags
}

# Role assignment for AKS to pull from ACR
resource "azurerm_role_assignment" "aks_acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

# PostgreSQL Server
resource "azurerm_postgresql_server" "postgres" {
  name                = "${var.project_name}-${var.environment}-postgres"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku_name = var.postgres_sku

  storage_mb                   = var.postgres_storage_mb
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.postgres_admin_username
  administrator_login_password = var.postgres_admin_password
  version                      = "11"
  ssl_enforcement_enabled      = true

  tags = var.tags
}

# PostgreSQL Database
resource "azurerm_postgresql_database" "db" {
  name                = "${var.project_name}_db"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.postgres.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

# PostgreSQL Firewall Rule (Allow Azure Services)
resource "azurerm_postgresql_firewall_rule" "allow_azure" {
  name                = "allow-azure-services"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_postgresql_server.postgres.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Redis Cache
resource "azurerm_redis_cache" "redis" {
  name                = "${var.project_name}-${var.environment}-redis-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku_name
  non_ssl_port_enabled = false
  minimum_tls_version = "1.2"

  redis_configuration {
    enable_authentication = true
  }

  tags = var.tags
}

# Storage Account for static assets
resource "azurerm_storage_account" "storage" {
  name                     = "${var.project_name}${var.environment}st${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = var.tags
}

# Storage Container for product images
resource "azurerm_storage_container" "images" {
  name                  = "product-images"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "blob"
}

# Get current Azure client config
data "azurerm_client_config" "current" {}

# Azure Key Vault for secrets management
resource "azurerm_key_vault" "kv" {
  name                       = "${var.project_name}-${var.environment}-kv-${random_string.suffix.result}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge",
      "Recover"
    ]
  }

  tags = var.tags
}

# Store database connection string in Key Vault
resource "azurerm_key_vault_secret" "db_connection" {
  name         = "database-connection-string"
  value        = "postgresql://${var.postgres_admin_username}:${var.postgres_admin_password}@${azurerm_postgresql_server.postgres.fqdn}:5432/${azurerm_postgresql_database.db.name}?sslmode=require"
  key_vault_id = azurerm_key_vault.kv.id
}

# Store Redis connection string in Key Vault
resource "azurerm_key_vault_secret" "redis_connection" {
  name         = "redis-connection-string"
  value        = "rediss://:${azurerm_redis_cache.redis.primary_access_key}@${azurerm_redis_cache.redis.hostname}:6380"
  key_vault_id = azurerm_key_vault.kv.id
}

# Store storage account key in Key Vault
resource "azurerm_key_vault_secret" "storage_key" {
  name         = "storage-account-key"
  value        = azurerm_storage_account.storage.primary_access_key
  key_vault_id = azurerm_key_vault.kv.id
}
