variable "k8s_namespace" {
    default = "monitoring"
    description = "kubernetes Namespace to deploy Monitoring components"
    type = string
  
}

variable "prometheus_helm_version" {
  default     = "54.2.2"
  description = "Helm Chart Version for Kube Prometheus Stack"
  type        = string
  
}

# variable "loki_helm_version" {
#   default     = "2.9.10"
#   description = "Helm Chart Version for Grafana Loki Stack"
#   type        = string
# }

variable "opentelemetry_helm_version" {
  default     = "0.43.1"
  description = "Helm Chart Version for Opentelemetry Stack"
  type        = string
}

# variable "tempo_helm_version" {
#   default     = "1.7.1"
#   description = "Helm Chart Version for Opentelemetry Stack"
#   type        = string
# }

# variable "tempo_svc" {
#   default     = "tempo"
#   type        = string
#   description = "Service Url for Tempo. Used by Otel collector and tempo datasource"
# }

variable "general_name" {
  default     = "python-app-monitoring"
  type        = string
  description = "Service name for metrics"
}
