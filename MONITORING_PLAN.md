# Zigbee Device Monitoring Implementation Plan

## Overview
This plan outlines the implementation of a monitoring system for Zigbee devices that tracks device responsiveness and alerts when devices exceed configurable thresholds.

## Core Requirements
1. **Alert Threshold**: Each device has an alert threshold in hours
2. **Auto-calculated Initial Threshold**: On first migration, set to 2x the interval between last two messages
3. **Editable via Madmin**: Alert threshold configurable through device admin interface
4. **Non-responsive Devices Screen**: Dedicated view for monitoring device health
5. **Disable Monitoring**: Per-device option to disable monitoring checks

## Implementation Architecture

### 1. Database Schema Changes

Add monitoring fields to the `devices` table:
```ruby
# Migration: add_monitoring_to_devices
add_column :devices, :alert_threshold_hours, :decimal, precision: 10, scale: 2
add_column :devices, :monitoring_enabled, :boolean, default: true
add_column :devices, :last_alert_at, :datetime
add_column :devices, :is_responsive, :boolean, default: true
add_column :devices, :last_checked_at, :datetime

add_index :devices, :monitoring_enabled
add_index :devices, :is_responsive
```

### 2. Model Enhancements

#### Device Model (`app/models/device.rb`)
```ruby
# Add monitoring methods
class Device < ApplicationRecord
  scope :monitored, -> { where(monitoring_enabled: true) }
  scope :non_responsive, -> { where(is_responsive: false, monitoring_enabled: true) }
  scope :responsive, -> { where(is_responsive: true, monitoring_enabled: true) }
  
  def calculate_initial_threshold
    # Calculate based on last two messages
    # Returns threshold in hours
  end
  
  def check_responsiveness
    # Check if device has exceeded threshold
    # Update is_responsive status
  end
  
  def time_since_last_message
    # Helper to calculate hours since last_heard_from
  end
  
  def alert_threshold_exceeded?
    # Check if current time exceeds threshold
  end
end
```

### 3. Migration Strategy

Create a migration that:
1. Adds the monitoring columns
2. Populates initial thresholds using a data migration:

```ruby
class AddMonitoringToDevices < ActiveRecord::Migration[7.0]
  def up
    # Add columns (as shown above)
    
    # Calculate initial thresholds
    Device.find_each do |device|
      messages = device.mqtt_messages.order(created_at: :desc).limit(2)
      
      if messages.count == 2
        interval_hours = (messages.first.created_at - messages.last.created_at).abs / 1.hour
        device.alert_threshold_hours = interval_hours * 2
      else
        # Default to 24 hours if insufficient data
        device.alert_threshold_hours = 24
      end
      
      device.save(validate: false)
    end
  end
end
```

### 4. Monitoring Service

Create `app/services/device_monitor.rb`:
```ruby
class DeviceMonitor
  def self.check_all_devices
    Device.monitored.find_each do |device|
      check_device(device)
    end
  end
  
  def self.check_device(device)
    hours_since_last = device.time_since_last_message
    was_responsive = device.is_responsive
    
    device.is_responsive = hours_since_last <= device.alert_threshold_hours
    device.last_checked_at = Time.current
    
    # Track when device becomes non-responsive
    if was_responsive && !device.is_responsive
      device.last_alert_at = Time.current
      # Future: Could trigger notifications here
    end
    
    device.save
  end
end
```

### 5. Background Process

Add to `Procfile`:
```
monitor: rails runner "DeviceMonitorProcess.run"
```

Create `app/models/device_monitor_process.rb`:
```ruby
class DeviceMonitorProcess
  def self.run
    Rails.logger.info "Starting device monitoring process..."
    
    loop do
      begin
        DeviceMonitor.check_all_devices
        Rails.logger.debug "Device monitoring check completed"
      rescue => e
        Rails.logger.error "Device monitoring error: #{e.message}"
      end
      
      sleep ENV.fetch('MONITOR_CHECK_INTERVAL', 300).to_i # Default 5 minutes
    end
  end
end
```

### 6. Madmin Integration

Update `app/madmin/resources/device_resource.rb`:
```ruby
class DeviceResource < Madmin::Resource
  # Existing attributes...
  
  # Add monitoring fields
  attribute :alert_threshold_hours do |field|
    field.form_component = :number_field
  end
  
  attribute :monitoring_enabled do |field|
    field.form_component = :check_box
  end
  
  attribute :is_responsive do |field|
    field.index = false  # Read-only, don't show in forms
  end
  
  attribute :last_alert_at
  attribute :last_checked_at
  
  # Add status badge
  def display_name(record)
    status = record.is_responsive ? "✅" : "⚠️"
    "#{status} #{record.friendly_name || record.ieee_addr}"
  end
end
```

### 7. Non-Responsive Devices Screen

#### Controller (`app/controllers/monitoring_controller.rb`)
```ruby
class MonitoringController < ApplicationController
  def index
    @non_responsive_devices = Device.non_responsive
                                   .order(last_alert_at: :desc)
                                   .includes(:mqtt_messages)
    
    @stats = {
      total_devices: Device.count,
      monitored_devices: Device.monitored.count,
      responsive_devices: Device.responsive.count,
      non_responsive_devices: Device.non_responsive.count
    }
  end
  
  def device_details
    @device = Device.find(params[:id])
    @recent_messages = @device.mqtt_messages
                             .order(created_at: :desc)
                             .limit(10)
  end
  
  def toggle_monitoring
    @device = Device.find(params[:id])
    @device.update(monitoring_enabled: params[:enabled])
    redirect_back(fallback_location: monitoring_path)
  end
end
```

#### View (`app/views/monitoring/index.html.erb`)
```erb
<div class="monitoring-dashboard">
  <h1>Device Monitoring Status</h1>
  
  <div class="stats">
    <div class="stat-card">
      <h3>Total Devices</h3>
      <p><%= @stats[:total_devices] %></p>
    </div>
    <div class="stat-card">
      <h3>Monitored</h3>
      <p><%= @stats[:monitored_devices] %></p>
    </div>
    <div class="stat-card">
      <h3>Responsive</h3>
      <p><%= @stats[:responsive_devices] %></p>
    </div>
    <div class="stat-card alert">
      <h3>Non-Responsive</h3>
      <p><%= @stats[:non_responsive_devices] %></p>
    </div>
  </div>
  
  <h2>Non-Responsive Devices</h2>
  <table class="devices-table">
    <thead>
      <tr>
        <th>Device</th>
        <th>Last Heard</th>
        <th>Threshold (hours)</th>
        <th>Time Exceeded</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      <% @non_responsive_devices.each do |device| %>
        <tr>
          <td><%= device.friendly_name || device.ieee_addr %></td>
          <td><%= time_ago_in_words(device.last_heard_from) %> ago</td>
          <td><%= device.alert_threshold_hours %></td>
          <td><%= device.time_since_last_message - device.alert_threshold_hours %> hours</td>
          <td>
            <%= link_to "Details", device_monitoring_path(device) %>
            <%= link_to "Disable Monitoring", toggle_monitoring_path(device, enabled: false), method: :post %>
            <%= link_to "Edit in Admin", madmin_device_path(device) %>
          </td>
        </tr>
      <% end %>
    </tbody>
  </table>
</div>
```

#### Routes (`config/routes.rb`)
```ruby
# Add monitoring routes
get '/monitoring', to: 'monitoring#index'
get '/monitoring/device/:id', to: 'monitoring#device_details', as: :device_monitoring
post '/monitoring/device/:id/toggle', to: 'monitoring#toggle_monitoring', as: :toggle_monitoring
```

### 8. Integration with Existing MQTT Listener

Update `app/models/mqtt_message.rb` in the `listen` method to reset device responsiveness:
```ruby
# When a message is received
device.update(
  last_heard_from: Time.current,
  is_responsive: true  # Reset responsive status when we hear from device
)
```

## Implementation Phases

### Phase 1: Database & Model (Day 1)
1. Create and run migration
2. Update Device model with monitoring methods
3. Test threshold calculations

### Phase 2: Monitoring Service (Day 1-2)
1. Implement DeviceMonitor service
2. Create background process
3. Test monitoring checks

### Phase 3: Admin Interface (Day 2)
1. Update Madmin resource
2. Test threshold editing
3. Add monitoring toggle

### Phase 4: Monitoring Dashboard (Day 2-3)
1. Create monitoring controller
2. Build non-responsive devices view
3. Add device detail views
4. Style the interface

### Phase 5: Testing & Refinement (Day 3)
1. Test with various device types
2. Tune default thresholds
3. Add error handling
4. Performance optimization

## Configuration Options

Environment variables for tuning:
```bash
MONITOR_CHECK_INTERVAL=300  # Check interval in seconds (default 5 minutes)
DEFAULT_ALERT_THRESHOLD=24  # Default threshold in hours for new devices
MONITOR_ENABLED=true        # Global toggle for monitoring system
```

## Future Enhancements

1. **Notification System**
   - Email/webhook alerts when devices become non-responsive
   - Configurable notification channels per device

2. **Threshold Intelligence**
   - Machine learning to predict optimal thresholds
   - Adaptive thresholds based on device type and behavior patterns

3. **Health Metrics**
   - Battery level monitoring and alerts
   - Signal strength tracking
   - Message frequency analysis

4. **Dashboard Improvements**
   - Real-time WebSocket updates
   - Historical responsiveness charts
   - Device groups and bulk operations

5. **API Endpoints**
   - RESTful API for external monitoring systems
   - Prometheus metrics export
   - Health check endpoints

## Testing Strategy

1. **Unit Tests**
   - Device model monitoring methods
   - DeviceMonitor service logic
   - Threshold calculations

2. **Integration Tests**
   - Background process execution
   - MQTT message reception and responsiveness updates
   - Madmin interface changes

3. **System Tests**
   - End-to-end monitoring flow
   - Non-responsive device detection
   - Alert threshold editing

## Performance Considerations

1. **Database Indexes**: Added indexes on `monitoring_enabled` and `is_responsive` for efficient queries
2. **Batch Processing**: Check devices in batches to avoid memory issues with large networks
3. **Caching**: Consider caching device status for dashboard views
4. **Background Processing**: Run monitoring checks in separate process to avoid blocking MQTT listener

## Security Considerations

1. **Access Control**: Consider adding authentication to monitoring dashboard
2. **Input Validation**: Validate threshold values (positive numbers, reasonable ranges)
3. **Rate Limiting**: Prevent abuse of toggle monitoring endpoint
4. **Audit Trail**: Log monitoring configuration changes

## Success Metrics

- All devices have appropriate alert thresholds
- Non-responsive devices are detected within configured intervals
- Admin can easily manage monitoring settings
- System handles 1000+ devices without performance degradation
- False positive rate < 5%