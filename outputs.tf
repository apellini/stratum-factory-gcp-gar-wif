output "gar_location" {
  description = "Region of the Artifact Registry repository."
  value       = var.location
}

output "gar_project_id" {
  description = "GCP project ID containing the registry."
  value       = var.project_id
}

output "gar_repository" {
  description = "Artifact Registry repository name."
  value       = google_artifact_registry_repository.this.name
}

output "gar_package_index_url" {
  description = "Full PyPI-compatible endpoint URL for pip install --index-url."
  value       = "https://${var.location}-python.pkg.dev/${var.project_id}/${var.repository_name}/simple/"
}

output "wif_provider" {
  description = "Full resource name of the WIF provider, used as workload_identity_provider in google-github-actions/auth."
  value       = google_iam_workload_identity_pool_provider.github_oidc.name
}

output "wif_service_account" {
  description = "Email of the publisher SA that GitHub Actions impersonates via WIF."
  value       = google_service_account.publisher.email
}
