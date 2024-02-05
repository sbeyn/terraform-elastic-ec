#!/bin/bash
# Exit if any command fails
set -e

# Parse input JSON and extract name, resource group and subscription
eval "$(jq -r '@sh "NAME=\(.name) RESOURCE_GROUP_NAME=\(.resource_group_name) SUBSCRIPTION=\(.subscription)"')"

# Get private endpoint using azure rest
RESOURCE_JSON=$(az rest --method get --uri https://management.azure.com/subscriptions/$SUBSCRIPTION/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Network/privateEndpoints/$NAME?api-version=2023-04-01)

# Extract the resourceGuid from JSON response
RESOURCE_GUID=$(echo $RESOURCE_JSON | jq -r '.properties.resourceGuid')

# Output the resourceGuid as JSON
jq -n --arg guid "$RESOURCE_GUID" '{"guid":$guid}'
