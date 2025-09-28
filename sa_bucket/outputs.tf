output "service_account_id" {
  value = yandex_iam_service_account.tf_sa.id
}

output "bucket_name" {
  value = yandex_storage_bucket.tf_state.bucket
}

output "access_key" {
  value = yandex_iam_service_account_static_access_key.tf_key.access_key
  sensitive = true
}

output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.tf_key.secret_key
  sensitive = true
}
