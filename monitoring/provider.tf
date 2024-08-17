terraform {
  # required_version = "~> 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13.1"
    }
    kubectl = {
       source  = "gavinbunney/kubectl"
       version = ">= 1.7.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"

}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "minikube"

  }
}

