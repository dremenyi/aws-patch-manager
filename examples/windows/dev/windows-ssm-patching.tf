
locals {
  product = tolist(["WindowsServer2016", "WindowsServer2012R2"])
  operating_system = "${module.baseline.operating_system}"
  classification = tolist(["CriticalUpdates", "SecurityUpdates"])
  severity = tolist(["Critical", "Important"])
  compliance_level = "high"
  env = "dev"
  patch_groups = tolist(["test-patch"])
  service_role_arn = "${module.maintenance-window.service_role_arn}"
  role_name = "${module.baseline.patch_baseline_label}-${local.env}-${local.operating_system}-patching-role"
  scan_maintenance_window_schedule = "cron(0 7/2 ? * * *)"

  tags = {
    terraform = "true"
    owner     = "coalfire"
    team      = "sre"
  }

}

######################################
# Create Patch Baselines for Windows #
######################################
module "baseline" {
  source = "../../../patching/modules/baselines/windows"

  # tags parameters
  env = lower(local.env)

  # patch baseline parameters
  compliance_level = upper(local.compliance_level)
  description      = "Windows - PatchBaseLine - Apply Critical Security Updates"
  tags             = merge(local.tags, {environment = local.env})

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



module "maintenance-window"{
    source = "../../../patching/modules/maintanence-windows"
    env = local.env
    operating_system = lower(local.operating_system)
    role_name = local.role_name
    service_role_arn = local.service_role_arn
    scan_maintenance_window_schedule = local.scan_maintenance_window_schedule
    patch_groups = local.patch_groups
    tags = merge(local.tags, {env = local.env}, {ManagedBy = "terraform"}, {operating_system = local.operating_system})
    enable_mode_scan = true

}


# register as default patch baseline our patch baseline
/*
module "register_patch_baseline_windows" {
  source = "../../register_default_patch_baseline"

  region                     = var.aws_region
  set_default_patch_baseline = true
  patch_baseline_id          = module.patch_baseline_windows.patch_baseline_id
  operating_system           = local.operating_system_windows
}
*/