package test

import (
    "fmt"
    "testing"
    "net/http"
    "strings"

    "github.com/gruntwork-io/terratest/modules/terraform"
    test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestEndToEndDeploymentScenario(t *testing.T) {

    fixtureFolder := "../examples/deployment_with_azure_private_endpoint"

    // User Terratest to deploy the infrastructure
    test_structure.RunTestStage(t, "create", func() {
        terraformOptions := &terraform.Options{
            // Indicate the directory that contains the Terraform configuration to deploy
            TerraformDir: fixtureFolder,
        }

        // Save options for later test stages
        test_structure.SaveTerraformOptions(t, fixtureFolder, terraformOptions)

        // Triggers the terraform init and terraform apply command
        terraform.InitAndApply(t, terraformOptions)
    })

    test_structure.RunTestStage(t, "idempotence", func() {

        terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)

        // Triggers to check Terraform configuration is idempotent when a second apply results in 0 changes
        terraform.ApplyAndIdempotent(t, terraformOptions)
    })

    test_structure.RunTestStage(t, "verify", func() {

        terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)

        // Run validation steps here
        testEndpointExists(t, terraformOptions)
    })

    // When the test is completed, destroy the infrastructure by calling terraform destroy
    test_structure.RunTestStage(t, "destroy", func() {

        terraformOptions := test_structure.LoadTerraformOptions(t, fixtureFolder)

        // Triggers the terraform destroy command
        defer terraform.Destroy(t, terraformOptions)
    })

}

func testEndpointExists(t *testing.T, terraformOptions *terraform.Options) {

    // Run `terraform output` to get the value of an output variable
    username := terraform.Output(t, terraformOptions, "elasticsearch_username")
    password := terraform.Output(t, terraformOptions, "elasticsearch_password")
    elasticsearch_endpoint := strings.Replace(terraform.Output(t, terraformOptions, "elasticsearch_https_endpoint"), "https://", "", 1)
    elasticsearch_endpoint = strings.Replace(elasticsearch_endpoint, ":9243", "", 1)

    _, err := http.Get(fmt.Sprintf("https://%s:%s@%s", username, password, elasticsearch_endpoint))
    if err != nil {
       t.Errorf(err.Error())
    } 
       
}
