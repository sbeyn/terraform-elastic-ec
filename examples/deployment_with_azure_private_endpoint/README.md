# example: deployment_with_azure_private_endpoint
Example ESS deployment connecting to an Azure Virtual Network from an Azure private endpoint.


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
| hashicorp/azurerm | =3.90.0 |
| elastic/ec | =0.9.0 |

## Environment variable

| Name | Description | Required |
|------|-------------|:--------:|
| EC_API_KEY | API keys can be used to authenticate against Elasticsearch Service. | yes |
| ARM_TENANT_ID  |  The Tenant ID which should be used. | yes |
| ARM_SUBSCRIPTION_ID |  The Subscription ID which should be used. | yes |
| ARM_CLIENT_ID |  The Client ID which should be used. | yes |
| ARM_CLIENT_SECRET |  The Client Secret which should be used. | yes |

