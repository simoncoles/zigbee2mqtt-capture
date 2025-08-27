# README

This is a rather simple Rails app that listens to MQTT messages and stores them in a database. 
It's designed to work with the [zigbee2mqtt](https://www.zigbee2mqtt.io/) project, but could be used with any MQTT messages.

There's three reasons you might want to use this:

1. As a sanity check to make sure that your Zigbee network is working whilst
   you're setting it up and maybe having issues with the connection to Home Assistant.
2. To see in detail what's going on on your Zigbee network.
3. Once you've got everything working, you can use something like Uptime Kuma to check
   the devices are communicating as expected.

Although you could run this for a long period, this is more intended as a debugging tool to be run for shorter periods and
then just throwing away the container and data. 

If you want it to run longer you might want to use Postgres as the database.

## Device Monitoring

The application includes a comprehensive device monitoring system that automatically tracks device responsiveness:

### Features

- **Automatic Threshold Calculation**: When first deployed, the monitoring system calculates an alert threshold for each device based on the interval between their last two messages (2x that interval, with bounds of 1-168 hours)
- **Configurable Thresholds**: Each device's alert threshold can be edited through the admin interface
- **Non-Responsive Alerts**: Devices that haven't been heard from within their threshold are marked as non-responsive
- **Monitoring Control**: Individual devices can have monitoring enabled/disabled
- **Background Process**: A separate monitoring process runs alongside the MQTT listener to check device status
- **Dashboard Interface**: Dedicated web interface at `/monitoring` to view device status and manage alerts
- **Auto-Recovery**: Devices automatically become responsive again when they send messages

### Accessing the Monitoring Dashboard

Visit `/monitoring` in your browser to access the monitoring dashboard. From there you can:
- View all non-responsive devices at a glance
- See device statistics and response rates
- Access detailed device information and message history
- Toggle monitoring on/off per device
- Reset alerts and recalculate thresholds
- Navigate to device admin pages for advanced configuration

### How It Works

1. **Initial Setup**: On first migration, the system analyzes the last two messages from each device to calculate an appropriate alert threshold (2x the interval)
2. **Continuous Monitoring**: The background process checks all devices every 5 minutes (configurable)
3. **Status Updates**: When a device exceeds its threshold, it's marked as non-responsive
4. **Recovery**: When a non-responsive device sends a message, it's automatically marked as responsive again

### Admin Interface Integration

The Madmin interface has been enhanced with monitoring features:
- Visual status indicators (✅ Responsive, ⚠️ Non-responsive, 🔕 Disabled)
- Editable threshold values
- Quick toggle buttons for enabling/disabling monitoring
- Filter scopes for responsive/non-responsive devices


## No authentication!

This is intended to run on a private network, so there's no authentication. If you expose this to the internet, you'll want to add some authentication.


## Running the Application

### Pre-requisites

To run this, you'll need to have a MQTT broker running. 

You'll also need to have Zigbee2MQTT running and sending messages to your MQTT broker.

### Docker

The easiest way to get this running is to use Docker.

The one environment variable you have to set is `MQTT_BROKER`. This should be the URL connection 
string for your MQTT broker, which has the domain name/IP address, username, and password in (plus the ssl or not).

To launch a Docker container with the `MQTT_BROKER` environment variable, you can use the following command:

```bash
docker run -e MQTT_BROKER=<your_mqtt_broker_url> ghcr.io/simoncoles/zigbee2mqtt-capture:main
```

Replace `<your_mqtt_broker_url>` with the URL connection string for your MQTT broker. Make sure to specify the appropriate image name for your Rails app.


This is what works for me with my Zigbee2MQTT setup:

```bash
docker run -e MQTT_BROKER="mqtt://mqtt-test:mqtt-test@192.168.1.15:1883" ghcr.io/simoncoles/zigbee2mqtt-capture:main
```


### Docker Compose

As an alternative to running this on the Docker command line, you can also use
[Docker Compose](https://docs.docker.com/compose/). Copy the `docker-compose.yml.example` file to 
`docker-compose.yml` in your desired location and edit the environment variables as needed.

The Docker Compose configuration runs three services from the same image:
- **web**: The Rails web server for the admin interface
- **mqtt**: The MQTT listener process that captures messages
- **monitor**: The device monitoring process that checks device responsiveness



## Configuration

There isn't much and it is all done with environment variables.

### Core Settings

- `DATABASE_URL` is your database connection string. It can be a Postgres or MySQL database, or if you specify nothing, it'll use SQLite.
- `ZIGBEE2MQTT_BASE` is your Zigbee2MQTT base URL which will be used to generate links to the Zigbee2MQTT web interface.
- `APPSIGNAL_PUSH_API_KEY` if you want to use AppSignal, this is your AppSignal API key.
- `FORCE_THREADS=YES` if you want to force the background threads to run. This is useful if want to force the threads to launch
  at startup in development. Otherwise, ignore this. 
- `MQTT_URL` is your MQTT broker URL.
- `PRUNE_HOURS` is how many hours old messages should be pruned. 9000 is a year. Default is 48 hours.

### Device Monitoring Settings

The application includes a device monitoring system that tracks device responsiveness and alerts when devices haven't been heard from:

- `MONITOR_ENABLED` - Enable/disable monitoring globally (default: `true`)
- `MONITOR_CHECK_INTERVAL` - How often to check devices in seconds (default: `300` - 5 minutes)
- `MONITOR_BATCH_SIZE` - Number of devices to process in each batch (default: `50`)
- `MONITOR_DEBUG` - Enable debug logging for monitoring (default: `false`) 


## Upgrades

If you want to preserve your data over upgrades, you'll need to do one of:

- Use Docker Compose and put your data in a volume
- Use Postgres or MySQL as the database

TODO When the server runs it'll create or migrate the database.

## AppSignal

If you want to keep an eye on errors, you can use [AppSignal](https://appsignal.com/). 
Set the environment variable `APPSIGNAL_PUSH_API_KEY` to your AppSignal API key.

## Development

There's a Dev Container setup for use with Github Codespaces or VS Code, Cursor etc. 

I have a `.env` file in my repository with the following:

```bash
MQTT_URL="mqtt://mqtt-user:mqtt-pass@192.1.1.2:1883"
ZIGBEE2MQTT_BASE="http://192.1.1.1:8080"
```

To run everything use the convenience script `bin/dev`.

This will start the web app, MQTT listener, and device monitor.

To start things individually:

- To run the web app: `rails server`
- To run the MQTT listener: `rails runner MqttMessage.listen`
- To run the device monitor: `rails runner DeviceMonitorProcess.run`

Admin interface is using https://github.com/excid3/madmin 
