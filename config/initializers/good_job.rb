Rails.application.configure do
  config.good_job.execution_mode = :external
  config.good_job.enable_cron = true
  config.good_job.cron = {
    device_prune: {
      cron: "0 * * * *",
      class: "DevicePruneJob"
    },
    mqtt_message_prune: {
      cron: "15 * * * *",
      class: "MqttMessagePruneJob"
    },
    raw_mqtt_message_prune: {
      cron: "30 * * * *",
      class: "RawMqttMessagePruneJob"
    },
    device_monitor: {
      cron: "*/5 * * * *",
      class: "DeviceMonitorJob"
    },
    device_monitor_stats: {
      cron: "5 * * * *",
      class: "DeviceMonitorStatsJob"
    },
    device_threshold_recalculation: {
      cron: "45 3 * * *",
      class: "DeviceThresholdRecalculationJob"
    }
  }
end
