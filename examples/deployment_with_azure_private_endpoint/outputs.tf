output "deployment_name" {
  value = module.example.deployment_name
}

output "deployment_id" {
  value = module.example.deployment_id
}

output "elasticsearch_version" {
  value = module.example.elasticsearch_version
}

output "elasticsearch_cloud_id" {
  value = module.example.elasticsearch_cloud_id
}

output "elasticsearch_https_endpoint" {
  value = module.example.elasticsearch_https_endpoint
}

output "kibana_https_endpoint" {
  value = module.example.kibana_https_endpoint
}

output "apm_https_endpoint" {
  value = module.example.apm_https_endpoint
}

output "fleet_https_endpoint" {
  value = module.example.apm_https_endpoint
}

output "enterprise_search_https_endpoint" {
  value = module.example.enterprise_search_https_endpoint
}

output "elasticsearch_username" {
  value = module.example.elasticsearch_username
}

output "elasticsearch_password" {
  value = module.example.elasticsearch_password
  sensitive = true
}
