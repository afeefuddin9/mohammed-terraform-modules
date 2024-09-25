# Creates a S3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = lower("${var.bucket-name}")
  tags = var.default_tags
}
resource "aws_s3_bucket_replication_configuration" "replication" {
  count = var.replication_role ? 1 : 0
  role = aws_iam_role.replication-role[0].arn
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    id = "rule-1"
    filter {
      prefix = ""
    }
    status = var.replication_role == true ? "Enabled" : "Disabled"
    destination {
      bucket        = var.create_replication_bucket == "true" ? aws_s3_bucket.s3_bucket_dest[0].arn : var.dest_bucket_arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership_acl]

  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}
resource "aws_s3_bucket_versioning" "s3_bucket_version1" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.enable_versions == "true" ? "Enabled" : "Disabled"
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    id = "rule-1"
    status = var.enable_lifecycle == "true" ? "Enabled" : "Disabled"
    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }
  }
}
# To block the public access to the bucket
resource "aws_s3_bucket_public_access_block" "block_bucket_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id
  restrict_public_buckets = var.restrict_public == "true" ? true : false
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}
resource "aws_iam_role" "replication-role" {
  count = var.replication_role ? 1 : 0
  name = "${var.bucket-name}-replication-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}
resource "aws_iam_policy" "replication-policy" {
  count = var.replication_role ? 1 : 0
  name = "${var.bucket-name}-replication-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.s3_bucket.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.s3_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      Resource = (
          var.create_replication_bucket == true ? 
          [aws_s3_bucket.s3_bucket_dest[0].arn] :
          [var.dest_bucket_arn]
        )
    }
  ]
}
POLICY
}
resource "aws_iam_policy_attachment" "replication" {
  count = var.replication_role ? 1 : 0
  name       = "${var.bucket-name}-replication"
  roles      = [aws_iam_role.replication-role[0].name]
  policy_arn = aws_iam_policy.replication-policy[count.index].arn
}

# Creates a S3 bucket
resource "aws_s3_bucket" "s3_bucket_dest" {
  count = var.create_replication_bucket ? 1 : 0
  bucket = var.replication-bucket-name
  tags = var.default_tags
}
# To block the public access to the bucket
resource "aws_s3_bucket_public_access_block" "block_bucket_public_access1" {
  count = var.create_replication_bucket ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket_dest[0].id
  restrict_public_buckets = var.restrict_public == "true" ? true : false
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
}
resource "aws_s3_bucket_acl" "bucket_acl2" {
  count = var.create_replication_bucket ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket_dest[0].id
  acl    = "private"
}
resource "aws_s3_bucket_versioning" "s3_bucket_version2" {
  count = var.create_replication_bucket ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket_dest[0].id
  versioning_configuration {
    status = var.enable_versions_dest_bucket == "true" ? "Enabled" : "Disabled"
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_configuration_dest_bucket" {
  count = var.create_replication_bucket ? 1 : 0
  bucket = aws_s3_bucket.s3_bucket_dest[0].id

  rule {
    id = "rule-1"
    status = var.enable_lifecycle_dest == "true" ? "Enabled" : "Disabled"
    transition {
      storage_class = "STANDARD_IA"
      days          = 30
    }
  }
}
