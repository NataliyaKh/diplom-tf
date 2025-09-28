variable "cloud_id" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "sa_key_path" {
  type = string
  description = "Path to json key file for tf service account"
}
