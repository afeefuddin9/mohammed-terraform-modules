#IAM role for glue data catalog
resource "aws_iam_role" "glue_service_role" {
  name = "${var.envPrefix}-glue-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com",
        "AWS" : ["arn:aws:iam::${var.aws_account_id}:root"]
      }
    }
  ]
}
EOF
}

# attach glue data catalog rule with glue policy
resource "aws_iam_role_policy_attachment" "glue_service_role_attach_policy" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = aws_iam_policy.glue_service_policy.arn
}

# policy defination accessing glue data catalog,glue connection ,glue crawler, s3 bucket,cloudwatch logs, EMR , redshift and RDS
resource "aws_iam_policy" "glue_service_policy" {
  name = "${var.envPrefix}-glue-service-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
         {
            "Sid": "Secrets",
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "*"
         },
         {
            "Sid": "s3",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket}/*"
            ]
        },
        {
            "Sid": "SNSPublishAction",
            "Effect": "Allow",
            "Action": [
                "sns:Publish",
                "sns:ListTopics"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

data "aws_iam_policy" "Glue_service_policy" {
  name = "AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "glue_service_role_attach_service_policy" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = data.aws_iam_policy.Glue_service_policy.arn
}