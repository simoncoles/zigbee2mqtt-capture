class MonitoringController < ApplicationController
  def index
    @non_responsive_devices = Device.non_responsive
                                   .order(last_alert_at: :desc)
                                   .includes(:mqtt_messages)
    
    @stats = {
      total_devices: Device.count,
      monitored_devices: Device.monitored.count,
      responsive_devices: Device.responsive.count,
      non_responsive_devices: Device.non_responsive.count,
      monitoring_disabled: Device.where(monitoring_enabled: false).count,
      response_rate: calculate_response_rate
    }
  end
  
  def device_details
    @device = Device.find(params[:id])
    @recent_messages = @device.mqtt_messages
                             .order(created_at: :desc)
                             .limit(20)
    
    # Calculate message frequency stats
    if @device.mqtt_messages.count >= 2
      messages = @device.mqtt_messages.order(created_at: :desc).limit(10).pluck(:created_at)
      if messages.length >= 2
        intervals = []
        (0...messages.length-1).each do |i|
          intervals << (messages[i] - messages[i+1]) / 3600.0  # Convert to hours
        end
        @avg_interval = (intervals.sum / intervals.length).round(2)
        @min_interval = intervals.min.round(2)
        @max_interval = intervals.max.round(2)
      end
    end
    
    @recent_readings = @device.readings
                             .order(created_at: :desc)
                             .limit(50)
  end
  
  def toggle_monitoring
    @device = Device.find(params[:id])
    @device.update(monitoring_enabled: params[:enabled] == 'true')
    
    flash[:notice] = if @device.monitoring_enabled?
                      "Monitoring enabled for #{@device.friendly_name || @device.ieee_addr}"
                    else
                      "Monitoring disabled for #{@device.friendly_name || @device.ieee_addr}"
                    end
    
    redirect_back(fallback_location: monitoring_index_path)
  end
  
  def reset_device
    @device = Device.find(params[:id])
    @device.update(
      is_responsive: true,
      last_alert_at: nil
    )
    
    flash[:notice] = "Alert reset for #{@device.friendly_name || @device.ieee_addr}"
    redirect_back(fallback_location: monitoring_index_path)
  end
  
  def recalculate_threshold
    @device = Device.find(params[:id])
    new_threshold = @device.calculate_initial_threshold
    @device.update(alert_threshold_hours: new_threshold)
    
    flash[:notice] = "Threshold recalculated to #{new_threshold} hours for #{@device.friendly_name || @device.ieee_addr}"
    redirect_back(fallback_location: device_monitoring_path(@device))
  end
  
  private
  
  def calculate_response_rate
    monitored = Device.monitored.count
    return 0 if monitored == 0
    
    responsive = Device.responsive.count
    ((responsive.to_f / monitored) * 100).round(1)
  end
end