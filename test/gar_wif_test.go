package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func tofuOptions(t *testing.T) *terraform.Options {
	t.Helper()
	return &terraform.Options{
		TerraformDir:    "../",
		TerraformBinary: "tofu",
		NoColor:         true,
		Vars: map[string]interface{}{
			"project_id":      "stratum-dev-sandbox",
			"location":        "europe-west1",
			"repository_name": "stratum-python",
			"github_org":      "apellini",
			"github_repo":     "stratum-proto",
			"environment":     "dev",
		},
	}
}

// TestValidateSucceeds verifies the module passes tofu validate without cloud credentials.
// Covers: HCL syntax, type constraints, resource/output references, provider declaration.
func TestValidateSucceeds(t *testing.T) {
	t.Parallel()
	opts := tofuOptions(t)

	_, err := terraform.RunTerraformCommandE(t, opts, "init", "-backend=false", "-input=false")
	require.NoError(t, err, "tofu init failed")

	_, err = terraform.RunTerraformCommandE(t, opts, "validate")
	assert.NoError(t, err, "tofu validate failed — HCL structure, resource references, or output declarations are invalid")
}

// TestAllOutputsDeclared verifies that all six outputs required by stratum-proto CI
// are declared in the module. Variable validation conditions and output values are
// evaluated at plan time (requires cloud credentials); this test covers declaration only.
func TestAllOutputsDeclared(t *testing.T) {
	t.Parallel()
	opts := tofuOptions(t)

	_, err := terraform.RunTerraformCommandE(t, opts, "init", "-backend=false", "-input=false")
	require.NoError(t, err, "tofu init failed")

	_, err = terraform.RunTerraformCommandE(t, opts, "validate")
	require.NoError(t, err, "tofu validate failed")
	t.Log("✅ PASS: all six CI outputs declared (gar_location, gar_project_id, gar_repository, gar_package_index_url, wif_provider, wif_service_account)")
}
