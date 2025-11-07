variable "sa_key_path" {
  description = "Path to Yandex Cloud service account key JSON"
  type        = string
}

variable "cloud_id" {
  description = "Yandex Cloud cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
}

variable "registry_name" {
  description = "Container Registry name"
  type        = string
  default     = "diploma-registry"
}

variable "vault_token" {
  type        = string
  description = "Vault token"
  sensitive   = true
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "service_account_key_file" {
  type        = string
  default     = "key.json"
}

variable "s3_access_key" {
  type        = string
  description = "Yandex Cloud S3 access key"
  sensitive   = true
}

variable "s3_secret_key" {
  type        = string
  description = "Yandex Cloud S3 secret key"
  sensitive   = true
}
