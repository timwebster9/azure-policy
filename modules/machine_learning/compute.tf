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
  dns_prefix          = "timwmlaks897987gf"

  default_node_pool {
    name           = "default"
    node_count     = 1
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

  machine_learning_workspace_id = azurerm_machine_learning_workspace.examplepass.id

  tags = {
    "stage" = "example"
  }
}