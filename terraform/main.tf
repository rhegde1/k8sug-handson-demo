resource "azurerm_resource_group" "rg" {
  name     = "handsonAKS-rg"
  location = "southeastasia"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "handsonaksdemo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "handsonaksdemo"
  # http_application_routing_enabled = true

  default_node_pool {
    name       = "default"
    node_count = "1"
    vm_size    = "standard_d2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}
