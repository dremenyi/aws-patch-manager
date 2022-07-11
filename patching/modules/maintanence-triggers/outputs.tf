output "patch_topic_arn" {
    value = aws_sns_topic.patch_baseline_topic.arn
}

output "service_role_arn" {
    value = aws_iam_role.ssm_maintenance_window_role.arn
}

output "role_name" {
    value = aws_iam_role.ssm_maintenance_window_role.name
    
}

output "notification_arn" {
    value = aws_sns_topic.patch_baseline_topic.arn
}
