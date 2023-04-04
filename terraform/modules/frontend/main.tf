# -----------------------------------
# Create S3 Bucket
# -----------------------------------
resource "aws_s3_bucket" "b" {
  bucket = var.BUCKET_NAME

  tags = {
    Project = var.MY_TAG
  }
}

# -----------------------------------
# Config S3 Bucket to be Public
# -----------------------------------
resource "aws_s3_bucket_acl" "b_is_public" {
  bucket = aws_s3_bucket.b.id
  acl    = "public-read"
}

# --------------------------------------------
# Config S3 Bucket to act as static web server
# --------------------------------------------
resource "aws_s3_bucket_website_configuration" "b_is_webserver" {
  bucket = aws_s3_bucket.b.id

  index_document {
    suffix = "index.html"
  }

  # error_document {
  #   key = "error.html"
  # }

  routing_rule {
    condition {
      key_prefix_equals = "/"
    }
    redirect {
      replace_key_prefix_with = "/index.html"
    }
  }
}

# --------------------------------------------
# Config S3 Bucket files versioning
# --------------------------------------------
resource "aws_s3_bucket_versioning" "b_versions_off" {
  bucket = aws_s3_bucket.b.id
  versioning_configuration {
    status = "Disabled"
  }
}

# --------------------------------------------
# Config S3 Bucket files encryption
# by default aws uses sse_algorithm = "AES256"
# --------------------------------------------
# resource "aws_s3_bucket_server_side_encryption_configuration" "b_crypto" {
#   bucket = aws_s3_bucket.b.id

#   rule {
#     bucket_key_enabled = false
#   }
# }

  # resource "aws_s3_bucket_server_side_encryption_configuration" "b_crypto" {
  #     - rule {
  #         - bucket_key_enabled = false -> null

  #         - apply_server_side_encryption_by_default {
  #             - sse_algorithm = "AES256" -> null
  #           }
  #       }
  #   }

# --------------------------------------------
# Upload files to S3 Bucket
# --------------------------------------------
resource "aws_s3_object" "b_file" {
  for_each = {
    "index.html" = ["${var.S3_SRC_FOLDER}/index.html", "text/html"]
    "styles.css" = ["${var.S3_SRC_FOLDER}/styles.css", "text/css"]
    # "scripts.js" = ["${var.S3_SRC_FOLDER}/scripts.js", "application/javascript"]
  }

  bucket = aws_s3_bucket.b.id
  acl    = "public-read"

  key    = each.key
  source = each.value[0]
  # to open as a webpage, instead of just download the file
  content_type = each.value[1]
  # etag allow tf to be awhere of changes
  etag = filemd5(each.value[0])
}

resource "local_file" "dynamic-js-file" {
  content = templatefile("${var.S3_SRC_FOLDER}/scripts.tpl", { apiBaseUrl = var.API_BASE_URL})
  filename = "./temp/script.js"
}

resource "aws_s3_object" "b_js_file" {
  bucket = aws_s3_bucket.b.id
  acl    = "public-read"

  key    = "scripts.js"
  source = "./temp/script.js"
  content_type = "application/javascript"
  source_hash = local_file.dynamic-js-file.content_sha256
}