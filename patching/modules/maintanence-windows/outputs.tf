output "service_role_arn" {
    value = aws_iam_role.ssm_maintenance_window_role.arn
}

output "tags" {
    value = var.tags
}
