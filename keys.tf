resource "random_password" "passwords" {
  for_each = var.db_users
  length   = 16
  special  = true
}
