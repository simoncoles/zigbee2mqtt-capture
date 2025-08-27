# Test the monitoring methods
puts 'Testing Device Monitoring Methods'
puts '================================='

# Check if we have any devices
device_count = Device.count
puts "Total devices: #{device_count}"

if device_count > 0
  # Test with first device
  device = Device.first
  puts "\nTesting with device: #{device.friendly_name || device.ieee_addr}"
  # Test calculate_initial_threshold
  threshold = device.calculate_initial_threshold
  puts "Calculated initial threshold: #{threshold} hours"
  # Test time_since_last_message
  time_since = device.time_since_last_message
  puts "Time since last message: #{time_since.round(2)} hours"
  # Test monitoring_status
  puts "Monitoring status: #{device.monitoring_status}"
  # Test alert_threshold_exceeded?
  puts "Alert threshold exceeded?: #{device.alert_threshold_exceeded?}"
  # Check current monitoring values
  puts "\nCurrent monitoring values:"
  puts "  Alert threshold: #{device.alert_threshold_hours} hours"
  puts "  Monitoring enabled: #{device.monitoring_enabled}"
  puts "  Is responsive: #{device.is_responsive}"
  puts "  Last checked at: #{device.last_checked_at}"
  # Test scopes
  puts "\nScope tests:"
  puts "  Monitored devices: #{Device.monitored.count}"
  puts "  Non-responsive devices: #{Device.non_responsive.count}"
  puts "  Responsive devices: #{Device.responsive.count}"
  # Test check_responsiveness
  puts "\nTesting check_responsiveness method..."
  device.check_responsiveness
  puts "After check:"
  puts "  Is responsive: #{device.is_responsive}"
  puts "  Last checked at: #{device.last_checked_at}"
else
  puts 'No devices found. Creating test device...'
  # Create a test device
  device = Device.create!(
    friendly_name: 'Test Device',
    ieee_addr: '0x123456789abcdef',
    last_heard_from: 2.hours.ago
  )
  # Create some test messages
  device.mqtt_messages.create!(
    topic: 'zigbee2mqtt/Test Device',
    content: '{}',
    created_at: 4.hours.ago
  )
  device.mqtt_messages.create!(
    topic: 'zigbee2mqtt/Test Device',
    content: '{}',
    created_at: 2.hours.ago
  )
  # Test methods
  threshold = device.calculate_initial_threshold
  puts "Calculated threshold for test device: #{threshold} hours"
  device.alert_threshold_hours = threshold
  device.save
  device.check_responsiveness
  puts "Test device status: #{device.monitoring_status}"
end
