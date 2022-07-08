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

variable "description" {
  description = "Desscription of the Patch Baseline"
  type        = string
}

variable "patch_baseline_label" {
  description = "This label will be added before 'env name' on all ssm patch resources"
  type        = string
  default     = "cf-ssm-pbl"
}

variable "baseline_approval_rules" {
  description = "list of approval rules defined in the patch baseline (Max 10 rules). For compliance_level, it means that if an approved patch is reported as missing, this is the severity of the compliance violation. Valid compliance levels include the following: CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL, UNSPECIFIED. The default value is UNSPECIFIED."
  type = list(object({
    approve_after_days : number
    compliance_level : string
    enable_non_security : bool
    patch_baseline_filters : list(object({
      name : string
      values : list(string)
    }))
  }))

  default = [
    {
      approve_after_days  = 7
      // The compliance level of a patch will default to unspecified if a patch isn't applied
      compliance_level    = "UNSPECIFIED"
      enable_non_security = false
      patch_baseline_filters = [
        {
          name   = "PRODUCT"
          values = ["WindowsServer2016", "WindowsServer2012R2"]
        },
        {
          name   = "CLASSIFICATION"
          values = ["CriticalUpdates", "SecurityUpdates"]
        },
        {
          name   = "MSRC_SEVERITY"
          values = ["Critical", "Important"]
        }
      ]
    }
  ]

}

variable "compliance_level" {
type        = string
  description = "Defines the compliance level for approved patches. This means that if an approved patch is reported as missing, this is the severity of the compliance violation. Valid compliance levels include the following: CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL, UNSPECIFIED. The default value is UNSPECIFIED."
  default     = "UNSPECIFIED"
}

variable "approved_patches" {
  description = "The list of approved patches for the SSM baseline"
  type        = list(string)
  default     = []
}

variable "rejected_patches" {
  description = "The list of rejected patches for the SSM baseline"
  type        = list(string)
  default     = []
}

variable "win_patch_group" {
  type = list(string)
  default = []
}