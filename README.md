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

## No authentication!

This is intended to run on a private network, so there's no authentication. If you expose this to the internet, you'll want to add some authentication.


## Running the Application

### Pre-requisites

To run this, you'll need to have a MQTT broker running. 

You'll also need to have Zigbee2MQTT running and sending messages to your MQTT broker.

### Docker

The easiest way to get this running is to use Docker.

The one environment variable you need to set is `MQTT_BROKER`. This should be the URL connection 
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

As an alternative to running this on the Docker command line, you can also use the
[Docker Compose](https://docs.docker.com/compose/) file in this repo. Copy the `docker-compose.yml` file to your
desired location and edit the environment variables as needed.



## Configuration

There isn't much. 


## Upgrades

If you want to preserve your data over upgrades, you'll need to do one of:

- Use Docker Compose and put your data in a volume
- Use Postgres or MySQL as the database

TODO When the server runs it'll create or migrate the database.

## Limitations

This is using the free version of Avo which doesn't allow the controls to be customised, so you're able to create, edit, and delete items in the
database. That doesn't make much sense, and ideally that would be prevented.