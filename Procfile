web: ./bin/rails server
mqtt: ./bin/rails runner "MqttMessage.listen"
monitor: ./bin/rails runner "DeviceMonitorProcess.run"
worker: bundle exec good_job start
