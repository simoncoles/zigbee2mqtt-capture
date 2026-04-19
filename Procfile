web: ./bin/rails server
mqtt: ./bin/rails runner "MqttMessage.listen"
monitor: ./bin/rails runner "DeviceMonitorProcess.run"
raw_prune: ./bin/rails runner "RawMqttMessage.prune_old"
