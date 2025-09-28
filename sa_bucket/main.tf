terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.99"
    }
  }
}

provider "yandex" {
  service_account_key_file = var.sa_key_path
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
}

resource "yandex_iam_service_account" "tf_sa" {
  name = "terraform-sa"
}

resource "yandex_iam_service_account_static_access_key" "tf_key" {
  service_account_id = yandex_iam_service_account.tf_sa.id
  description        = "Access key for Terraform"
}

resource "yandex_storage_bucket" "tf-state-nkh-d" {
  bucket     = var.bucket_name
  access_key = yandex_iam_service_account_static_access_key.tf_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.tf_key.secret_key
  anonymous_access_flags {
    read = false
    list = false
  }

  lifecycle_rule {
    id      = "expire-old"
    enabled = true

    expiration {
      days = 90
    }
  }

}

resource "yandex_resourcemanager_folder_iam_member" "sa-storage-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.tf_sa.id}"
}

