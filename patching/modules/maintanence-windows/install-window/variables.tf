variable "env" {
  type = string
}

variable "tags" {
  description = "map of tags to associated on patch_baseline"
  type        = map(string)
  default = {
    terraform = "true"
    owner     = "coalfire"
    team      = "sre"
  }
}

variable "operating_system" {
    type = string
}

variable "patch_baseline_label" {
    default = "cf-ssm-pbl"
}

variable "role_name" {
  description = "Role name for the maintenance window."
}

# ===========================================================
# Maintenance Windows for Install - Variables
# ===========================================================
variable "install_patch_groups" {
  description = "The list of install patching groups, one target will be created per entry in this list. Update default value only if you know what you do"
  type        = list(string)
  default     = ["INSTALL"]
}

variable "install_maintenance_window_schedule" {
  description = "The schedule of the install Maintenance Window in the form of a cron or rate expression"
  type        = string
}

variable "s3_bucket_prefix_install_logs" {
  description = "The directories where the logs of scan will be stored"
  type        = string
  default     = "install"
}

variable "task_install_priority" {
  description = "Priority assigned to the install task. 1 is the highest priority. Default 1"
  type        = number
  default     = 1
}

variable "enable_notification" {
  description = "Enable/Disable the SNS notification for install patchs"
  type        = bool
  default     = true
}

variable "install_maintenance_windows_targets" {
  description = "The map of tags for targetting which EC2 instances will be patched"
  type = list(object({
    key : string
    values : list(string)
    }
    )
  )
  default = []
}

# ===========================================================
# Maintenance Windows - Variables
# ===========================================================
variable "maintenance_window_duration" {
  description = "The duration of the maintenence windows (hours)"
  type        = number
  default     = 3
}

variable "maintenance_window_cutoff" {
  description = "The number of hours before the end of the Maintenance Window that Systems Manager stops scheduling new tasks for execution"
  type        = number
  default     = 1
}

variable "max_concurrency" {
  description = "The maximum amount of concurrent instances of a task that will be executed in parallel"
  type        = number
  default     = 20
}

variable "max_errors" {
  description = "The maximum amount of errors that instances of a task will tollerate before being de-scheduled"
  type        = number
  default     = 11
}

variable "service_role_arn" {
  description = "The sevice role ARN to attach to the Maintenance windows"
  type        = string
}

variable "reboot_option" {
  description = "Parameter 'Reboot Option' to pass to the windows Task Execution. By Default : 'RebootIfNeeded'. Possible values : RebootIfNeeded, NoReboot"
  type        = string
  default     = "RebootIfNeeded"
}

variable "notification_events" {
  description = "The list of different events for which you can receive notifications. Valid values: All, InProgress, Success, TimedOut, Cancelled, and Failed"
  type        = list(string)
  default     = ["All"]
}

variable "notification_type" {
  description = "When specified with Command, receive notification when the status of a command changes. When specified with Invocation, for commands sent to multiple instances, receive notification on a per-instance basis when the status of a command changes. Valid values: Command and Invocation"
  type        = string
  default     = "Command"
}

variable "notification_arn" {
  description = "The SNS ARN to use for notification"
  type        = string
}

variable "patch_groups" {}
