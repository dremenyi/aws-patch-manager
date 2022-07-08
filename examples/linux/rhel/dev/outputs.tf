/*
output "patch_baseline_id" {
  description = "Patch Baseline Id"
  value       = aws_ssm_patch_baseline.rhel_baseline.id
}
*/
output "operating_system" {
  description = "The operating system"
  value = module.rhel_baseline.operating_system
}

output "tags" {
  value = module.rhel_maintenance_window.tags
}