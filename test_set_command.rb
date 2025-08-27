#!/usr/bin/env ruby
require "mqtt"
require "json"

# Test script to send a /set command to a device
# Usage: rails runner test_set_command.rb

mqtt_url = ENV["MQTT_URL"]
if mqtt_url.nil?
  puts "Error: MQTT_URL environment variable not set"
  exit 1
end

# Find a test device
device = Device.first
if device.nil?
  puts "Error: No devices found in database"
  exit 1
end

puts "Testing with device: #{device.friendly_name} (IEEE: #{device.ieee_addr})"

# Connect to MQTT broker
puts "Connecting to MQTT broker at: #{mqtt_url}"
client = MQTT::Client.connect(mqtt_url)

# Construct the /set topic for the device
set_topic = "zigbee2mqtt/#{device.friendly_name}/set"

# Create a test command payload
command_payload = {
  state: "ON",
  brightness: 128
}.to_json

puts "Sending command to topic: #{set_topic}"
puts "Command payload: #{command_payload}"

# Publish the command
client.publish(set_topic, command_payload)
puts "Command sent successfully!"

# Wait a moment to ensure delivery
sleep(1)

client.disconnect
puts "Test completed"
