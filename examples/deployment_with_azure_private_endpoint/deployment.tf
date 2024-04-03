data "azurerm_client_config" "current" {}

resource "random_string" "this" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "example" {
  name = "rg-tftest${random_string.this.result}"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-tftest${random_string.this.result}"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_subnet" "subnet" {
  name                 = "default"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_private_endpoint" "example" {
  name                = "pe-tftest${random_string.this.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                              = "psc-tftest${random_string.this.result}"
    private_connection_resource_alias = "westeurope-prod-001-privatelink-service.190cd496-6d79-4ee2-8f23-0667fd5a8ec1.westeurope.azure.privatelinkservice"
    is_manual_connection              = true
    request_message                   = "Awaiting Approval"
  }
}

data "azapi_resource" "private_endpoint" {
  name      = azurerm_private_endpoint.example.name
  parent_id = azurerm_resource_group.example.id
  type      = "Microsoft.Network/privateEndpoints@2023-04-01"

  response_export_values = ["*"]
}

module "example" {
  source = "../.."

  name = "tftest${random_string.this.result}"
  region = "azure-westeurope"

  stack_version = "8.12.?"

  obs_enabled = true

  elasticsearch = {
    autoscale = false
    hot = {
      size = "8g"
      zone_count = 3
      autoscaling = {
        max_size = "64g"
        max_size_resource = "memory"
      }
   }
    config = {
      user_settings_yaml = file("./es_settings.yaml")
    }
  }

  kibana = {
    size = "2g"
    zone_count = 1
    config = {
      user_settings_yaml = <<EOF
xpack.security.authc.providers:
  saml.saml1:
    order: 0
    realm: "saml1"
  basic.basic1:
    order: 1
      EOF
    }
  }

  enterprise_search = {
    size = "2g"
    zone_count = 2
  }
  
  traffic_filter_rulesets = [
    {
      name = "ips-tftest${random_string.this.result}"
      type = "ip"
      rules = [
        {
          source = "0.0.0.0/0"
        }
      ]
    },
    { 
      name = "pe-tftest${random_string.this.result}"
      type = "azure_private_endpoint"
      rules = [
        {
          azure_endpoint_name = azurerm_private_endpoint.example.name
          azure_endpoint_guid = jsondecode(data.azapi_resource.private_endpoint.output).properties.resourceGuid
        }
      ]
    }
  ]

  tags = {
    Terraform = true
    ApplicationName = "tftest${random_string.this.result}"
    Environment = "test"
    Owner = "iac"
  }
}
