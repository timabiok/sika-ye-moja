# Banking prescriptive DCR — syslog (auth/daemon) + performance counters → Log Analytics.
resource "azurerm_monitor_data_collection_rule" "linux_baseline" {
  name                = "${var.name_prefix}-dcr-linux-baseline"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  destinations {
    log_analytics {
      workspace_resource_id = var.log_analytics_workspace_id
      name                  = "loganalytics"
    }
  }

  data_sources {
    syslog {
      name           = "syslog-banking"
      facility_names = ["auth", "authpriv", "daemon", "kern", "syslog"]
      log_levels     = ["Warning", "Error", "Critical", "Alert", "Emergency", "Info"]
      streams        = ["Microsoft-Syslog"]
    }

    performance_counter {
      name                          = "perf-banking"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "Processor(*)\\% Processor Time",
        "Processor(*)\\% Idle Time",
        "Memory(*)\\% Used Memory",
        "Memory(*)\\Available MBytes",
        "LogicalDisk(*)\\% Free Space",
        "LogicalDisk(*)\\Disk Reads/sec",
        "LogicalDisk(*)\\Disk Writes/sec",
        "Network Interface(*)\\Bytes Total/sec",
      ]
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["loganalytics"]
  }

  data_flow {
    streams      = ["Microsoft-Perf"]
    destinations = ["loganalytics"]
  }
}

resource "azurerm_role_assignment" "dcr_metrics_publisher" {
  for_each = toset(var.vm_identity_principal_ids)

  scope                = azurerm_monitor_data_collection_rule.linux_baseline.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = each.value
}
