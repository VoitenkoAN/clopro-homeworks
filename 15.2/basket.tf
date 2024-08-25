resource "yandex_storage_bucket" "backet" {
  access_key = yandex_iam_service_account_static_access_key.sa-backet-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-backet-static-key.secret_key
  bucket     = "voitenko-${formatdate("DD-MM-YYYY", timestamp())}"
  force_destroy = true 
  anonymous_access_flags {
    read = true
    list = false
  }
}

resource "yandex_storage_object" "picture" {
  access_key = yandex_iam_service_account_static_access_key.sa-backet-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-backet-static-key.secret_key
  bucket     = "voitenko-${formatdate("DD-MM-YYYY", timestamp())}"
  key        = "Razrabotka.webp"
  source     = "./Razrabotka.webp"
  content_type = "image/webp"
  acl = "public-read"
  depends_on = [
    yandex_storage_bucket.backet
  ]
}