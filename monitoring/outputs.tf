output "grafana_password_id" {
  value = random_password.password.result
  sensitive = true
}