
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

variable "patch_baseline_label" {
    default = "cf-ssm-pbl"
}

variable "role_name" {
  description = "Role name for the maintenance window."
}

variable "service_role_arn" {
  description = "The sevice role ARN to attach to the Maintenance windows"
  type        = string
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

variable "enable_notification_install" {
  description = "Enable/Disable the SNS notification for install patchs"
  type        = bool
  default     = true
}

variable "operating_system" {
  description = "Your OS"
}

variable "bucket" {
  description = "The bucket your patch logs will be sent to"
}