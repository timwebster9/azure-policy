resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_application_insights" "example" {
  name                = "ml-ai-566456"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

resource "azurerm_key_vault" "example" {
  name                = "timwmlkv098g90f8g"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "premium"
}

resource "azurerm_storage_account" "example" {
  name                     = "mlstorage34566456"
  location                 = azurerm_resource_group.example.location
  resource_group_name      = azurerm_resource_group.example.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "aks" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.2.0.0/24"]
}

# should pass
resource "azurerm_machine_learning_workspace" "examplepass" {
  name                    = "mlworkspace678733567"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id
  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_policy_definition.public_network_access,
    azurerm_policy_definition.diagnostics,
    azurerm_management_group_policy_assignment.public_network_access,
    azurerm_management_group_policy_assignment.diagnostics
  ]
}

resource "azurerm_machine_learning_compute_cluster" "test" {
  name                          = "example"
  location                      = azurerm_resource_group.example.location
  vm_priority                   = "LowPriority"
  vm_size                       = "Standard_DS2_v2"
  machine_learning_workspace_id = azurerm_machine_learning_workspace.examplepass.id
  subnet_resource_id            = azurerm_subnet.example.id

  scale_settings {
    min_node_count                       = 0
    max_node_count                       = 1
    scale_down_nodes_after_idle_duration = "PT30S" # 30 seconds
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "timwmlaks98798g7"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  default_node_pool {
    name           = "default"
    node_count     = 3
    vm_size        = "Standard_D3_v2"
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_machine_learning_inference_cluster" "example" {
  name                  = "example"
  location              = azurerm_resource_group.example.location
  cluster_purpose       = "FastProd"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.example.id
  description           = "This is an example cluster used with Terraform"

  machine_learning_workspace_id = azurerm_machine_learning_workspace.example.id

  tags = {
    "stage" = "example"
  }
}

# should fail
resource "azurerm_machine_learning_workspace" "examplefail" {
  name                    = "mlworkspace234235245"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_policy_definition.public_network_access,
    azurerm_policy_definition.diagnostics,
    azurerm_management_group_policy_assignment.public_network_access,
    azurerm_management_group_policy_assignment.diagnostics
  ]
}