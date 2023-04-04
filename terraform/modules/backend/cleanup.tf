# --------------------------------------
# Delete temp files/folder after destroy
# --------------------------------------
resource "null_resource" "delete-temp-local-files" {
  provisioner "local-exec" {
    when    = destroy
    command = "rm -R ./temp"
  }
}