#########################################
# Create SNS topic for Patch management #
#########################################
locals {
    operating_system = var.operating_system
    bucket = "${var.patch_baseline_label}-${var.env}-patching-logs-bucket"

}


###############################################
# Maintenance Windows for installing patching #
###############################################
resource "aws_ssm_maintenance_window" "install_window" {
  name     = "${var.patch_baseline_label}-${var.env}-${var.operating_system}-patch-maintenance-install-window"
  schedule = var.install_maintenance_window_schedule
  duration = var.maintenance_window_duration
  cutoff   = var.maintenance_window_cutoff
}

resource "aws_ssm_maintenance_window_task" "task_install_patches" {
  window_id        = aws_ssm_maintenance_window.install_window.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"
  priority         = var.task_install_priority
  service_role_arn = var.service_role_arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors


  targets {
    key    = "WindowTargetIds"
    values = aws_ssm_maintenance_window_target.target_install.*.id
  }


  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Install"]
      }
      parameter {
        name   = "RebootOption"
        values = [var.reboot_option]
      }
      output_s3_bucket     = local.bucket
      output_s3_key_prefix = var.s3_bucket_prefix_install_logs

      service_role_arn = var.service_role_arn
      dynamic "notification_config" {
        for_each = var.enable_notification ? [1] : []
        content {
          notification_arn    = var.notification_arn
          notification_events = var.notification_events
          notification_type   = var.notification_type
        }
      }
    }
  }
}


resource "aws_ssm_maintenance_window_target" "target_install" {
  window_id     = aws_ssm_maintenance_window.install_window.id
  resource_type = "INSTANCE"
  dynamic "targets" {
    for_each = length(var.install_maintenance_windows_targets) > 0 ? var.install_maintenance_windows_targets : []
    content {
      key    = targets.value.key
      values = targets.value.values
    }
  }

  dynamic "targets" {
    for_each = length(var.install_maintenance_windows_targets) == 0 ? [1] : []
    content {
      key    = "tag:Patch Group"
      values = var.install_patch_groups
    }
  }
}