    variable "resource_group_name" {
      description = "The name of the resource group."
      type        = string
      default     = "myResourceGroup"
    }

    variable "location" {
      description = "The Azure region where resources will be created."
      type        = string
      default     = "West US"
    }

    variable "cluster_name" {
      description = "The name of the AKS cluster."
      type        = string
      default     = "myAKSCluster"
    }

    variable "dns_prefix" {
      description = "DNS prefix for the AKS cluster."
      type        = string
      default     = "myakscluster"
    }

    variable "kubernetes_version" {
      description = "The Kubernetes version for the AKS cluster."
      type        = string
      default     = "1.33.0" # Update to a supported version if needed
    }

    variable "node_count" {
      description = "The number of nodes in the default node pool."
      type        = number
      default     = 1
    }

    variable "vm_size" { # azure aks requires the size be at least 2 cores and 4GB RAM
      description = "The size of the virtual machines in the node pool."
      type        = string
      # default     = "Standard_DS2_v2" # expensive for (Dev 2 vCPUs, 7GB RAM)
      default	  = "Standard_B2s" # 2 cores 4GB RAM about $0.0416 / hour, likely best DEV instance on azure AKS
      # default     = "Standard_B1ms" # too small for aks (1vCPU 2GB RAM)
    }
