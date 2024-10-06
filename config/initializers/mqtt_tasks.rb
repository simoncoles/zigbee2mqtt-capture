# Launches background tasks for listening to MQTT messages and pruning old ones

# Putting this in an after_initialize block so we can be sure Rails is loaded
Rails.application.config.after_initialize do
  # Only run these tasks in production, we can do them in development manually
  # if Rails.env.production? || ENV["FORCE_THREADS"] == "YES"
  #   # The listener thread
  #   Thread.new do
  #     Rails.application.executor.wrap do
  #       MqttMessage.listen
  #     end
  #   end

  #   # The pruning thread
  #   Thread.new do
  #     Rails.application.executor.wrap do
  #       MqttMessage.prune_old
  #     end
  #   end
  # end
end
