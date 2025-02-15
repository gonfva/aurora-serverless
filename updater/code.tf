locals {}

resource "null_resource" "prepare_deployment" {
  provisioner "local-exec" {
    command = <<EOT
      pip install psycopg2-binary -t ${var.package_path}
      cp -r ${path.module}/files/* ${var.package_path}
    EOT
  }
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = var.package_path
  output_path = "${var.package_path}.zip"

  depends_on = [null_resource.prepare_deployment]
}
