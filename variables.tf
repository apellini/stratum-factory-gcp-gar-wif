variable "project_id" {
  description = "GCP project ID in which to create the GAR repository and WIF resources."
  type        = string
}

variable "location" {
  description = "GCP region for the Artifact Registry repository (e.g. 'europe-west1')."
  type        = string
}

variable "repository_name" {
  description = "Name of the Artifact Registry repository (e.g. 'stratum-python')."
  type        = string
}

variable "repository_format" {
  description = "Artifact Registry format. Defaults to PYTHON; set to DOCKER or NPM for other use cases."
  type        = string
  default     = "PYTHON"
}

variable "github_org" {
  description = "GitHub organisation that owns the publishing repository (e.g. 'apellini')."
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name (without org prefix) whose OIDC tokens may impersonate the publisher SA (e.g. 'stratum-proto')."
  type        = string
}

variable "environment" {
  description = "Deployment environment label (e.g. 'dev', 'stage', 'main'). Used to namespace the WIF pool ID."
  type        = string

  validation {
    condition     = contains(["dev", "stage", "main"], var.environment)
    error_message = "environment must be one of: dev, stage, main."
  }
}

variable "additional_repos" {
  description = "Extra GitHub repos that each get their own OIDC provider in the SAME pool, impersonating the SAME publisher SA. Map of provider-suffix => repo name (without org), e.g. { common = \"stratum-common\" } creates provider id github-oidc-common-<environment>. Defaults to empty (no extra providers)."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Labels applied to all resources that support them."
  type        = map(string)
  default     = {}
}
