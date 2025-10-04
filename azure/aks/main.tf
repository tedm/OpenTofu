    # Configure the Azure provider
    provider "azurerm" {
      features {}
      subscription_id = "<Your Azure Subscription here>" 
      # Best practice is to use a Secrets Manager rather than above line
    }

    # Create a resource group
    resource "azurerm_resource_group" "rg" {
      name     = var.resource_group_name
      location = var.location
    }

    # Create an AKS cluster
    resource "azurerm_kubernetes_cluster" "aks" {
      name                = var.cluster_name
      location            = azurerm_resource_group.rg.location
      resource_group_name = azurerm_resource_group.rg.name
      dns_prefix          = var.dns_prefix
      kubernetes_version  = var.kubernetes_version

      default_node_pool {
        name       = "default"
        node_count = var.node_count
        vm_size    = var.vm_size
      }

      identity {
        type = "SystemAssigned"
      }

      tags = {
        Environment = "Dev"
      }
    }