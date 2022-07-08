locals {
   operating_system = "WINDOWS"
}
resource "aws_ssm_patch_baseline" "baseline" {

  name             = format("%s-%s-%s-baseline", var.patch_baseline_label, var.env, lower(local.operating_system))
  description      = var.description
  operating_system = local.operating_system

  approved_patches                  = var.approved_patches
  rejected_patches                  = var.rejected_patches
  approved_patches_compliance_level = var.compliance_level
  
  dynamic "approval_rule" {
    for_each = var.baseline_approval_rules
    content {

      approve_after_days  = approval_rule.value.approve_after_days
      compliance_level    = approval_rule.value.compliance_level
      enable_non_security = approval_rule.value.enable_non_security

      # patch filter values : https://docs.aws.amazon.com/cli/latest/reference/ssm/describe-patch-properties.html
      dynamic "patch_filter" {
        for_each = approval_rule.value.patch_baseline_filters

        content {
          key    = patch_filter.value.name
          values = patch_filter.value.values
        }
      }
    }
  }
  tags = merge(var.tags, { Name = format("%s-%s-%s", var.patch_baseline_label, var.env, lower(local.operating_system)) })
}

resource "aws_ssm_patch_group" "patchgroup" {
    baseline_id = aws_ssm_patch_baseline.baseline.id
    patch_group = format("%s-%s-%s", lower(local.operating_system), var.env, "patchgroup")
}

/*
resource "aws_ssm_patch_group" "scan_patchgroup" {
  for_each = var.enable_mode_scan ? toset(var.scan_patch_groups) : []
    baseline_id = aws_ssm_patch_baseline.baseline.id
    patch_group = each.key
}
*/