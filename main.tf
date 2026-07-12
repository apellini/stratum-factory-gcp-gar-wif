# GAR Python repository
resource "google_artifact_registry_repository" "this" {
  project       = var.project_id
  location      = var.location
  repository_id = var.repository_name
  format        = var.repository_format
  description   = "stratum-proto Python stub registry (managed by OpenTofu)"
  labels        = var.tags
}

# Dedicated publisher service account
resource "google_service_account" "publisher" {
  project      = var.project_id
  account_id   = "stratum-proto-publisher"
  display_name = "stratum-proto GAR publisher (WIF keyless)"
}

# Grant publisher SA write access to the repository
resource "google_artifact_registry_repository_iam_member" "publisher_writer" {
  project    = var.project_id
  location   = var.location
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.publisher.email}"
}
