variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "sa_key_path" {
  type = string
  description = "Path to json key file for tf service account"
}

variable "vault_token" {
  type        = string
  sensitive   = true
}
