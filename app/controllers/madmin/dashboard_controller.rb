module Madmin
  class DashboardController < ApplicationController
    def show
      # Get device statistics
      total_devices = Device.count
      monitored_devices = Device.where(monitoring_enabled: true).count
      responsive_devices = Device.where(monitoring_enabled: true, is_responsive: true).count
      non_responsive_devices = Device.where(monitoring_enabled: true, is_responsive: false).count
      monitoring_disabled = Device.where(monitoring_enabled: false).count
      
      response_rate = if monitored_devices > 0
        ((responsive_devices.to_f / monitored_devices) * 100).round
      else
        0
      end
      
      @stats = {
        total_devices: total_devices,
        monitored_devices: monitored_devices,
        responsive_devices: responsive_devices,
        non_responsive_devices: non_responsive_devices,
        monitoring_disabled: monitoring_disabled,
        response_rate: response_rate
      }
      
      # Get non-responsive devices for the alert table
      @non_responsive_devices = Device.where(monitoring_enabled: true, is_responsive: false)
                                      .order(last_heard_from: :asc)
                                      .limit(10)
      
      # Get recent data for charts/activity
      @recent_messages = MqttMessage.order(created_at: :desc).limit(10)
      @recent_readings = Reading.order(created_at: :desc).limit(10)
      
      # Count messages by hour for the last 24 hours
      @messages_by_hour = MqttMessage.where(created_at: 24.hours.ago..Time.current)
                                     .group_by_hour(:created_at, last: 24)
                                     .count
      
      # Count readings by hour for the last 24 hours  
      @readings_by_hour = Reading.where(created_at: 24.hours.ago..Time.current)
                                 .group_by_hour(:created_at, last: 24)
                                 .count
    rescue => e
      # If groupdate gem is not available, just use basic counts
      @messages_by_hour = {}
      @readings_by_hour = {}
    end
  end
end