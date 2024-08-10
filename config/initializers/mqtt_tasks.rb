# Launches background tasks for listening to MQTT messages and pruning old ones

# We need the logger which might not be here yet
require 'logger'

# THis is a helper method to retry a block until it executes successfully
# As Rails will take a moment to load all of the application's classes,
# we need to wait until the MqttMessage class is loaded before we can call its methods
def try_until_ready(&block)
  retries = 0
  max_retries = 600 # Maximum number of retries to avoid infinite loop

  while retries < max_retries
    begin
      block.call
      break # Exit the loop if the block executes successfully
    rescue NameError => e
      if e.name == :const_missing && e.message.include?("MqttMessage")
        logger.warn("Waiting for the rest of the application to be loaded...")
        sleep(1) # Wait for 1 second before retrying
        retries += 1
      else
        raise e # Re-raise the exception if it's not the expected one
      end
    end
  end
end

sleep 5

# The listener thread
Thread.new do
  try_until_ready do
    Rails.application.executor.wrap do
      MqttMessage.listen
    end
  end
end

# The pruning thread
Thread.new do
  try_until_ready do
    Rails.application.executor.wrap do
      MqttMessage.prune_old
    end
  end
end
