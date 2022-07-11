
locals {
  operating_system = var.operating_system
  bucket = var.bucket
}
resource "aws_sns_topic" "patch_baseline_topic" {
    name = "${var.patch_baseline_label}-${var.env}-${local.operating_system}-patching-notification"
}

############################################
# Create S3 Bucket for centralized logging #
############################################

resource "aws_s3_bucket" "patch_log_bucket" {
  bucket = local.bucket #"${var.patch_baseline_label}-${var.env}-patching-logs-bucket"
  tags = merge(var.tags, {Name = "${var.patch_baseline_label}-${var.env}-patching-logs-bucket"})
}

resource "aws_s3_bucket_acl" "patch_bucket_acl" {
  bucket = aws_s3_bucket.patch_log_bucket.id
  acl = "private"
}

#################################################################
# Create Custom Role for patchManagement                        #
# and attach AmazonSSMMaintenanceWindowRole policy to the role  #
#################################################################
resource "aws_iam_role" "ssm_maintenance_window_role" {
  name = var.role_name
  path = "/system/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com","ssm.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "role_attach_ssm_mw" {
  role       = aws_iam_role.ssm_maintenance_window_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}

resource "aws_iam_role_policy_attachment" "role_attach_sns_mw" {
  role       = aws_iam_role.ssm_maintenance_window_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
}