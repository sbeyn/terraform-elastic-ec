output "deployment_name" {
  value = var.name
}

output "deployment_id" {
  value = ec_deployment.this.id
}

output "elasticsearch_version" {
  value = ec_deployment.this.version
}

output "elasticsearch_cloud_id" {
  value = jsondecode(jsonencode(ec_deployment.this.elasticsearch)).cloud_id
}

output "elasticsearch_https_endpoint" {
  value = jsondecode(jsonencode(ec_deployment.this.elasticsearch)).https_endpoint
}

output "kibana_https_endpoint" {
  value = var.kibana != null ? jsondecode(jsonencode(ec_deployment.this.kibana)).https_endpoint : null
}

output "apm_https_endpoint" {
  value = var.integrations_server != null ? jsondecode(jsonencode(ec_deployment.this.integrations_server)).endpoints.apm : null
}

output "fleet_https_endpoint" {
  value = var.integrations_server != null ? jsondecode(jsonencode(ec_deployment.this.integrations_server)).endpoints.fleet : null
}

output "enterprise_search_https_endpoint" {
  value = var.enterprise_search != null ? jsondecode(jsonencode(ec_deployment.this.enterprise_search)).https_endpoint : null
}

output "elasticsearch_username" {
  value = jsondecode(jsonencode(ec_deployment.this.elasticsearch_username))
}

output "elasticsearch_password" {
  value = jsondecode(jsonencode(ec_deployment.this.elasticsearch_password))
  sensitive = true
}
