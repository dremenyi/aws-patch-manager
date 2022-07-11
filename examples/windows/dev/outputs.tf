
output "operating_system" {
  description = "The operating system"
  value       = module.scan-baseline.operating_system
}

output "install-operating_system" {
  description = "The operating system"
  value       = module.install-baseline.operating_system
}

output "pbl" {
  description = "The operating system"
  value       = module.install-baseline.patch_baseline_label
}

output "scan-pbl" {
  description = "The operating system"
  value       = module.scan-baseline.patch_baseline_label
}

output "scan_baseline_id" {
  description = "Patch Baseline Id"
  value       = module.scan-baseline.patch_baseline_id
}

output "install_baseline_id" {
  description = "Patch Baseline Id"
  value       = module.install-baseline.patch_baseline_id
}
# output "role_arn" {
#   value = module.triggers-example.service_role_arn
# }


# output "patch_topic_arn" {
#   value = module.triggers-example.patch_topic_arn
# }

