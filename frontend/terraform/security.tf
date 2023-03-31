# --------------------------------------------
# Create S3 Bucket allowed access policy
# --------------------------------------------
data "aws_iam_policy_document" "allow_access_to_site" {
  version = "2012-10-17"
  statement {

    # sid = statement id (optional)
    sid = "PublicReadGetObject"

    effect = "Allow"

    # to whom it applyes
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.b.arn}/*",
    ]
  }
}

# --------------------------------------------
# Implement S3 Bucket allowed access policy
# --------------------------------------------
resource "aws_s3_bucket_policy" "allow_access_to_site" {
  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.allow_access_to_site.json
}