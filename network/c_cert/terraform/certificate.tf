# -----------------------------------
# To use the cert with CloudFront it
# MUST be generated in region N. Virginia
# that's way I use another provider
# -----------------------------------
# -----------------------------------
# Create a new certificate
# -----------------------------------
resource "aws_acm_certificate" "gabtec-cert" {
  # provider          = aws.N_Virginia
  domain_name       = "*.gabtec.fun"
  validation_method = "DNS"
  # subject_alternative_names = ["*.gabtec.fun", "www.gabtec.fun"]


  # this is recommended to replace a certificate which is currently in use
  # in case of tf code updates
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Project = var.MY_TAG
  }
}