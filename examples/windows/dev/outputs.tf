/*
output "patch_baseline_id" {
  description = "Patch Baseline Id"
  value       = module.baseline.baseline.id
}
*/

output "operating_system" {
  description = "The operating system"
  value = module.baseline.operating_system
}
output "pbl" {
  description = "The operating system"
  value = module.baseline.patch_baseline_label
}
