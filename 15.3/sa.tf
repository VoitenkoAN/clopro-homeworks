resource "yandex_iam_service_account" "sa-backet" {
  name = "sa-backet"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-backet-editor" {
  folder_id = var.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-backet.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-backet-static-key" {
  service_account_id = yandex_iam_service_account.sa-backet.id
  description        = "static access key for object storage"
}
