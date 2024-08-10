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

To run this, you'll need to have a MQTT broker running. I'm using [RabbitMQ](https://www.rabbitmq.com/), 
but you could use [Mosquitto](https://mosquitto.org/) or any other MQTT broker.

You'll also need to have Zigbee2MQTT running and sending messages to your MQTT broker.

The easiest way to get this running is to use Docker

### Docker

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