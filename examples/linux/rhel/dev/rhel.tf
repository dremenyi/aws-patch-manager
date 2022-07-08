locals {
    compliance_level = "high"
    env = "dev"
    operating_system = "${module.rhel_baseline.operating_system}"
    scan_maintenance_window_schedule = "cron(0 7/2 ? * * *)"
    patch_groups = ["rhel"]
    
    tags = {
        terraform = "true"
        owner     = "coalfire"
        team      = "sre"
    }

}

module "rhel_baseline" {
    source = "../../../../patching/modules/baselines/linux/rhel"
    env = local.env
    compliance_level = upper(local.compliance_level)
} 

module "rhel_maintenance_window" {
    source = "../../../../patching/modules/maintanence-windows"
    operating_system = local.operating_system
    env = local.env
    role_name = "${module.rhel_baseline.patch_baseline_label}-${local.env}-${local.operating_system}-patching-role"
    service_role_arn = "${module.rhel_maintenance_window.service_role_arn}"
    scan_maintenance_window_schedule = local.scan_maintenance_window_schedule
    patch_groups = local.patch_groups
    tags = merge(local.tags, {operating_system = local.operating_system})
    enable_mode_scan = true
}