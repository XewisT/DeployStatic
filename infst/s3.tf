# Prod Bucket
resource "aws_s3_bucket" "prod_bucket" {
  bucket = "prod-xew"
}

# Dev Bucket
resource "aws_s3_bucket" "dev_bucket" {
  bucket = "dev-xew"
}

# Website Configuration for Prod Bucket
resource "aws_s3_bucket_website_configuration" "prod_bucket_website" {
  bucket = aws_s3_bucket.prod_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Website Configuration for Dev Bucket
resource "aws_s3_bucket_website_configuration" "dev_bucket_website" {
  bucket = aws_s3_bucket.dev_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Public Access for Prod Bucket
resource "aws_s3_bucket_public_access_block" "prod_allow_public_access" {
  bucket = aws_s3_bucket.prod_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Public Access for Dev Bucket
resource "aws_s3_bucket_public_access_block" "dev_allow_public_access" {
  bucket = aws_s3_bucket.dev_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Introduce a null resource to add a delay for consistency
resource "null_resource" "prod_delay" {
  depends_on = [aws_s3_bucket.prod_bucket]
  provisioner "local-exec" {
    command = "sleep 10"  # Adjust the sleep duration as needed
  }
}

resource "null_resource" "dev_delay" {
  depends_on = [aws_s3_bucket.dev_bucket]
  provisioner "local-exec" {
    command = "sleep 10"  # Adjust the sleep duration as needed
  }
}

resource "aws_s3_bucket_policy" "prod_bucket_policy" {
  bucket = aws_s3_bucket.prod_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCloudFrontServicePrincipal",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.oai.iam_arn}"
        },
        Action = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.prod_bucket.bucket}/*"
      }
    ]
  })
}


# # Bucket Policy for Dev Bucket
# resource "aws_s3_bucket_policy" "dev_bucket_policy" {
#   bucket = aws_s3_bucket.dev_bucket.id
#   depends_on = [null_resource.dev_delay]

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "PublicReadGetObject",
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "s3:GetObject",
#       "Resource": "${aws_s3_bucket.dev_bucket.arn}/*"
#     }
#   ]
# }
# EOF
# }

resource "aws_s3_bucket_policy" "dev_bucket_policy" {
  bucket = aws_s3_bucket.dev_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCloudFrontServicePrincipal",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.oai.iam_arn}"
        },
        Action = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.dev_bucket.bucket}/*"
      }
    ]
  })
}