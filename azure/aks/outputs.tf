    output "aks_cluster_name" {
      value       = azurerm_kubernetes_cluster.aks.name
      description = "The name of the AKS cluster."
    }

    output "aks_kube_config" {
      value       = azurerm_kubernetes_cluster.aks.kube_config_raw
      description = "The raw Kubernetes configuration for the AKS cluster."
      sensitive   = true
    }