data "ec_stack" "latest" {
  version_regex              = var.stack_version
  region                     = var.region
}

resource "ec_deployment" "this" {
  name                       = try(var.global_settings.prefix, null) != null || var.prefix_name != null ? format("%s-%s", lookup(var.global_settings, "prefix", var.prefix_name), var.name) : var.name
  alias                      = try(var.alias, null)
  region                     = var.region
  version                    = data.ec_stack.latest.version
  deployment_template_id     = var.deployment_template_id
  elasticsearch              = merge(var.elasticsearch, local.elasticsearch)
  kibana                     = var.kibana
  integrations_server        = var.integrations_server
  enterprise_search          = var.enterprise_search
  tags                       = var.tags

  observability = {
    deployment_id            = lookup(var.observability, "deployment_id", "self")
    logs                     = lookup(var.observability, "logs", true) 
    metrics                  = lookup(var.observability, "metrics", true) 
    ref_id                   = lookup(var.observability, "ref_id", null)
  }
}

resource "ec_deployment_traffic_filter" "rulesets" {
  count                      = length(var.traffic_filter_rulesets)

  name                       = lookup(var.traffic_filter_rulesets[count.index], "name")
  region                     = var.region
  type                       = lookup(var.traffic_filter_rulesets[count.index], "type")
  description                = lookup(var.traffic_filter_rulesets[count.index], "description", null)

  dynamic "rule" {
    for_each                 = lookup(var.traffic_filter_rulesets[count.index], "type") == "ip" ? lookup(var.traffic_filter_rulesets[count.index], "rules") : []
    content {
      source                 = rule.value.source
    }
  }

  dynamic "rule" {
    for_each                 = lookup(var.traffic_filter_rulesets[count.index], "type") == "gcp_private_service_connect_endpoint" ? lookup(var.traffic_filter_rulesets[count.index], "rules") : []
    content {
      source                 = rule.value.source
    }
  }

  dynamic "rule" {
    for_each                 = lookup(var.traffic_filter_rulesets[count.index], "type") == "azure_private_endpoint" ? lookup(var.traffic_filter_rulesets[count.index], "rules") : []
    content {
      azure_endpoint_name    = rule.value.azure_endpoint_name
      azure_endpoint_guid    = rule.value.azure_endpoint_guid
    }
  }

  depends_on = [ec_deployment.this]
}

resource "ec_deployment_traffic_filter_association" "attach" {
  count                      = length(ec_deployment_traffic_filter.rulesets)

  traffic_filter_id          = lookup(ec_deployment_traffic_filter.rulesets[count.index], "id")
  deployment_id              = ec_deployment.this.id
  depends_on                 = [ec_deployment.this, ec_deployment_traffic_filter.rulesets]
}
