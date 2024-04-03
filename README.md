# Terraform module-elasticsearch-service-cluster

Provides an Elastic Cloud deployment resource, which allows deployments to be created, updated, and deleted with traffic filter rules are used to limit inbound traffic to deployment resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| git | >= 2.30.1 | 
| golang | >= 1.15.1 |
| terraform | >= 1.2.5 |

## Providers

| Name | Version |
|------|---------|
| elastic/ec | >=0.9.0 |

## Environment variable

| Name | Description | Required |
|------|-------------|:--------:|
| EC_API_KEY | API keys can be used to authenticate against Elasticsearch Service. | yes |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enabled | Enabled or disabled module | bool | true | no |
| name | Name of the deployment. | string | | yes |
| prefix_name | Name of the deployment. | string | null | no |
| alias | Name of the deployment. | string | null | no |
| region | Elasticsearch Service (ESS) region where to create the deployment. | string | azure-westeurope | no | 
| stack_version | Elastic Stack version to use for all the deployment resources. | string | latest | no |
| deployment_template_id | Deployment template identifier to create the deployment from. | string | azure-general-purpose | no | 
| elasticsearch | Elasticsearch cluster topology and config | map | hot = { size = "1g" zone_count = 1 } | no |  
| kibana | Kibana topology and config | map | { size = "1g" zone_count = 1 } | no | 
| integrations_server | Integrations Server topology and config | map | { size = "1g" zone_count = 1 } | no |
| enterprise_search | Enterprise Search topology and config | map | null | no |
| traffic_filter_rulesets | Source ip from which the ruleset accepts traffic. | list | [] | no |
| observability | Logs and metrics Ship to a deployment. | map | { deployment_id = "self" logs = true metrics = true } | no |
| obs_enabled | Logs and metrics enable Ship to a deployment. | bool | false | no |
| global_settings | Global settings object for the current deployment CAF. | map | {} | no |


## Outputs

| Name | Description |
|------|-------------|
| deployment_id | Deployment identifier. |
| elasticsearch_version | Elasticsearch region. |
| elasticsearch_cloud_id | Encoded Elasticsearch credentials to use in Beats or Logstash. |
| elasticsearch_https_endpoint | Elasticsearch resource HTTPs endpoint. |
| kibana_https_endpoint | Kibana resource HTTPs endpoint. |
| apm_https_endpoint | Apm resource HTTPs endpoint. |
| fleet_https_endpoint | Fleet resource HTTPs endpoint. |
| enterprise_search_https_endpoint | Enterprise Search resource HTTPs endpoint. |
| elasticsearch_username | Auto-generated Elasticsearch username. |
| elasticsearch_password | Auto-generated Elasticsearch password. |


## Tests validation
### Scenario 'deployment_with_azure_private_endpoint' (terraform 1.2.5): 
- create: plan and apply terraform with 1 Elasticsearch cluster with Azure Private Endpoint
- validate: check endpoint Elasticsearch
- destroy: destroy all resources
### Scenario 'deployment_with_azure_private_endpoint' (terraform 1.7.2): 
- create: plan and apply terraform with 1 Elasticsearch cluster with Azure Private Endpoint
- validate: check endpoint Elasticsearch
- destroy: destroy all resources
