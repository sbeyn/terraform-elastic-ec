variable "name" {
  type = string
  description = "Name of the deployment.  "
}

variable "prefix_name" {
  type = string
  default = null
  description = "Prefix name of the deployment.  "
}

variable "alias" {
  type = string
  default = null
  description = "Alias of the deployment.  "
}

variable "region" {
  type    = string
  default = "azure-westeurope"
  validation {
    condition = contains(["gcp-asia-east1", "gcp-asia-northeast1", "gcp-asia-northeast3", "gcp-asia-south1", "gcp-asia-southeast1", "gcp-asia-southeast2", "gcp-australia-southeast1", "gcp-europe-north1", "gcp-europe-west1", "gcp-europe-west2", "gcp-europe-west3", "gcp-europe-west4", "gcp-europe-west9", "gcp-northamerica-northeast1", "gcp-southamerica-east1", "gcp-us-central1", "gcp-us-east1", "gcp-us-east4", "gcp-us-west1", "aws-af-south-1", "aws-ap-east-1", "aws-ap-northeast-2", "aws-ap-south-1", "aws-ca-central-1", "aws-eu-central-1", "aws-eu-north-1", "aws-eu-south-1", "aws-eu-west-2", "aws-eu-west-3", "aws-me-south-1", "aws-us-east-2", "azure-australiaeast", "azure-brazilsouth", "azure-canadacentral", "azure-centralindia", "azure-centralus", "azure-eastus", "azure-eastus2", "azure-francecentral", "azure-japaneast", "azure-northeurope", "azure-southafricanorth", "azure-southcentralus", "azure-southeastasia", "azure-uksouth", "azure-westeurope", "azure-westus2"], var.region)
    error_message = "This region is not exist, Check deployment templates from https://www.elastic.co/guide/en/cloud/current/ec-regions-templates-instances.html"
  }
  description = "Elasticsearch Service (ESS) region where to create the deployment.  "
}

variable "stack_version" {
  type    = string
  default = "latest"
  description = "Elasticsearch Service (ESS) region where to create the deployment.  "
}

variable "deployment_template_id" {
  type    = string
  default = "azure-general-purpose"
  validation {
    condition = contains(["aws-cpu-optimized", "aws-cpu-optimized-arm", "aws-cpu-optimized-faster-warm", "aws-cpu-optimized-faster-warm-arm", "aws-general-purpose", "aws-general-purpose-arm", "aws-storage-optimized", "aws-storage-optimized-dense", "aws-vector-search-optimized-arm", "azure-cpu-optimized", "azure-general-purpose", "azure-storage-optimized", "gcp-cpu-optimized", "gcp-general-purpose", "gcp-storage-optimized", "gcp-storage-optimized-dense"], var.deployment_template_id)
    error_message = "This template is not exist, Check deployment templates from https://www.elastic.co/guide/en/cloud/current/ec-regions-templates-instances.html"
  }
  description = "Elasticsearch Service (ESS) deployment_template_id where to create the deployment.  "
}

variable "observability" {
  type    = any
  default = {
    deployment_id = "self"
    logs = true
    metrics = true
  }
  description = "Elasticsearch Service (ESS) observability of the deployment.  "
}

variable "elasticsearch" {
  type    = any
  default = {
    hot = {
      size = "1g"
      zone_count = 1
    }
  }
  validation {
    condition = can(var.elasticsearch.hot) || (can(var.elasticsearch["hot"]) && (can(var.elasticsearch["warm"]) || can(var.elasticsearch["cold"]) || can(var.elasticsearch["coordinating"]) || can(var.elasticsearch["master"]) || can(var.elasticsearch["ml"])))
    error_message = "A topology refers to an Elasticsearch data tier, such as hot_content, warm, cold, coordinating, master or ml. If this variable is not null, id hot_content is required."
  }
  description = "Topologies Elasticsearch.  "
}

variable "kibana" {
  type    = any
  default = {
    size = "1g"
    zone_count = 1
  }
  description = "Kibana topology.  "
}

variable "enterprise_search" {
  type    = any
  default = null
  description = "Enterprise Search topology.  "
}

variable "integrations_server" {
  type    = any
  default = {
    size = "1g"
    zone_count = 1
  }
  description = "APM topology.  "
}

variable "traffic_filter_rulesets" {
  type = list(any)
  default = []
  description = "Rulesets accepts traffic.  "
}

variable "tags" {
  default     = {}
  type        = map
  description = "Tags shared by all resources of this module. Will be merged with any other specific tags by resource.  "
}

variable "global_settings" {
  type    = any
  default = {}
  description = "Global settings object for the current deployment."
}

locals {
  elasticsearch = {
    for key, value in var.elasticsearch :
      key => merge({autoscaling={}}, value) if contains(["hot","warm","cold","frozen","master","coordinating","ml"], key)
  }
}
