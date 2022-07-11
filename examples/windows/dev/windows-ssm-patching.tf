
locals {
  product                             = tolist(["WindowsServer2016", "WindowsServer2012R2"])
  classification                      = tolist(["CriticalUpdates", "SecurityUpdates"])
  severity                            = tolist(["Critical", "Important"])
  scan_patch_groups                        = tolist(["SCAN"])
  compliance_level                    = "high"
  env                                 = "dev"
  operating_system                    = "windows"
  scan_maintenance_window_schedule    = "cron(0 7/1 ? * * *)"
  install_maintenance_window_schedule = "cron(0 7/1 ? * * *)"


  tags = {
    terraform = "true"
    owner     = "coalfire"
    team      = "sre"
  }

}

######################################
# Create Patch Baselines for Windows #
######################################
module "scan-baseline" {
  source = "../../../patching/modules/baselines/windows"
  patch_group_name = format("%s-%s-%s", local.env, lower(local.operating_system), "scan-patchgroup")
  # tags parameters
  env = lower(local.env)

  # patch baseline parameters
  compliance_level = upper(local.compliance_level)
  description      = "Windows - PatchBaseLine - Apply Critical Security Updates"
  tags             = merge(local.tags, { environment = local.env })

  # define rules inside patch baseline
  baseline_approval_rules = [
    {
      approve_after_days  = 7
      compliance_level    = "UNSPECIFIED"
      enable_non_security = false
      patch_baseline_filters = [

        {
          name   = "PRODUCT"
          values = local.product
        },
        {
          name   = "CLASSIFICATION"
          values = local.classification
        },

        {
          name   = "MSRC_SEVERITY"
          values = local.severity
        }
      ]
    }
  ]
  # parameters for scan : associated patch_group "scan" to this patch baseline


}

module "install-baseline" {
  source = "../../../patching/modules/baselines/windows"
  patch_group_name = format("%s-%s-%s", local.env, lower(local.operating_system), "install-patchgroup")
  # tags parameters
  env = lower(local.env)

  # patch baseline parameters
  compliance_level = upper(local.compliance_level)
  description      = "Windows - PatchBaseLine - Apply Critical Security Updates"
  tags             = merge(local.tags, { environment = local.env })

  # define rules inside patch baseline
  baseline_approval_rules = [
    {
      approve_after_days  = 7
      compliance_level    = "UNSPECIFIED"
      enable_non_security = false
      patch_baseline_filters = [

        {
          name   = "PRODUCT"
          values = local.product
        },
        {
          name   = "CLASSIFICATION"
          values = local.classification
        },

        {
          name   = "MSRC_SEVERITY"
          values = local.severity
        }
      ]
    }
  ]
  # parameters for scan : associated patch_group "scan" to this patch baseline


}

module "scan-depend" {
  source           = "../../../patching/modules/maintanence-triggers"
  env              = local.env
  service_role_arn = module.scan-depend.service_role_arn
  notification_arn = module.scan-depend.patch_topic_arn
  operating_system = local.operating_system
  bucket           = lower("${module.scan-baseline.patch_baseline_label}-${local.env}-${module.scan-baseline.operating_system}-scan-logs-bucket")
  role_name = lower("${module.scan-baseline.patch_baseline_label}-${local.env}-${local.operating_system}-patching-scan-role")
}

module "install-depend"{

  source           = "../../../patching/modules/maintanence-triggers"
  env              = local.env
  service_role_arn = module.install-depend.service_role_arn
  notification_arn = module.install-depend.patch_topic_arn
  operating_system = local.operating_system
  bucket           = lower("${module.install-baseline.patch_baseline_label}-${local.env}-${module.install-baseline.operating_system}-scan-logs-bucket")
  role_name        = lower("${module.install-baseline.patch_baseline_label}-${local.env}-${local.operating_system}-patching-install-role")

}



module "maintenance-window-scan" {
  source                           = "../../../patching/modules/maintanence-windows/scan-window"
  env                              = local.env
  operating_system                 = lower(local.operating_system)
  role_name                        = module.scan-depend.role_name
  service_role_arn                 = module.scan-depend.service_role_arn
  scan_maintenance_window_schedule = local.scan_maintenance_window_schedule
  scan_patch_groups                     = local.scan_patch_groups
  tags                             = merge(local.tags, { env = local.env }, { ManagedBy = "terraform" }, { operating_system = local.operating_system })
  enable_notification              = true
  notification_arn                 = module.scan-depend.notification_arn
}

module "maintenance-window-install" {
  source                              = "../../../patching/modules/maintanence-windows/install-window"
  env                                 = local.env
  operating_system                    = lower(local.operating_system)
  role_name                           = module.install-depend.role_name
  service_role_arn                    = module.install-depend.service_role_arn
  install_maintenance_window_schedule = local.install_maintenance_window_schedule
  patch_groups                        = ["INSTALL"]
  tags                                = merge(local.tags, { env = local.env }, { ManagedBy = "terraform" }, { operating_system = local.operating_system })
  enable_notification         = true
  notification_arn                    = module.install-depend.notification_arn
}