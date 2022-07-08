output "patch_baseline_id" {
  description = "Patch Baseline Id"
  value       = aws_ssm_patch_baseline.baseline.id
}

output "operating_system" {
  description = "The operating system"
  value = local.operating_system
}

output "patch_baseline_label" {
  description = "Patch Baseline Label Output"
  value = var.patch_baseline_label
}