# creating a random password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
# creating namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.k8s_namespace
  }
}

#  creating kubernetes secrete for grafana
resource "kubernetes_secret" "grafana_password" {
  metadata {
    name      = "grafana-admin-secret"
    namespace = var.k8s_namespace
  }
  data = {
    admin-user = "admin"
    admin-password = random_password.password.result

  }
  depends_on = [ kubernetes_namespace.monitoring ]
}


# Deploy Prometheus and Grafana via Helm charts
resource "helm_release" "prometheus_operator" {
  name             = "kube-prometheus-stack"
  chart            = "kube-prometheus-stack"
  version          = var.prometheus_helm_version
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = var.k8s_namespace
  cleanup_on_fail  = true
  create_namespace = true

  values = [templatefile(
    "${path.module}/files/prometheus.yaml")]

depends_on = [kubernetes_secret.grafana_password]
}

# Logging Helm Chart


# Opentelemetry operator helm chart
resource "helm_release" "opentelemetry" {
  name             = "opentelemetry-operator"
  chart            = "opentelemetry-operator"
  version          = var.opentelemetry_helm_version
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  namespace        = var.k8s_namespace
  create_namespace = true
  cleanup_on_fail  = true
  depends_on = [kubernetes_namespace.monitoring]
}


# Otel collector manifest file
resource "kubectl_manifest" "otel_collector" {
  yaml_body = templatefile("${path.module}/files/collector.yaml", {
    # collector_exporter_endpoint = var.tempo_svc
    k8s_namespace               = var.k8s_namespace
  })
  depends_on = [
    helm_release.opentelemetry,
    helm_release.grafana_tempo
  ]
}

# Instrumentation manifest file
resource "kubectl_manifest" "instrumentation" {
  yaml_body = templatefile("${path.module}/files/instrumentation.yaml", {
    service_name = var.general_name
    k8s_namespace = var.k8s_namespace
  })
  depends_on = [
    helm_release.opentelemetry,
    helm_release.grafana_tempo
  ]
}



# service monitoring manifest file
resource "kubectl_manifest" "service_monitoring" {
  yaml_body = templatefile("${path.module}/files/servicemonitor.yaml", {
    service_name = var.general_name
    k8s_namespace = var.k8s_namespace
  })
  depends_on = [
       helm_release.prometheus_operator
  ]
}

