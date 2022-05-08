package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestUnitTest(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "unit-test",
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndPlan(t, terraformOptions)
	terraform.ApplyAndIdempotent(t, terraformOptions)
}
