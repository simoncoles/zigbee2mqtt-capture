# README

This is a rather simple Rails app that listens to MQTT messages and stores them in a database. 
It's designed to work with the [zigbee2mqtt](https://www.zigbee2mqtt.io/) project, but could be used with any MQTT messages.

Although you could run this for a long period, this is more intended as a debugging tool to be run for shorter periods and
then just throwing away the container and data. 

If you want it to run longer you might want to use Postgres as the database.

## Running

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



## No authentication!

I'm using this on a private network, so there's no authentication...


## Development

You can just open this in VSCode and start the DevContainer.

The tricky bit is secrets because you'll want to connect to your MQTT broker. 

I use 1Password for my secrets, so I have a `1Password.env` file that I source to set the environment variables. When I create a new DevContainer, I need to inject the secrets from 1Password into the `.env` file.

```shell
export OP_SERVICE_ACCOUNT_TOKEN=<enter token here>

op inject --in-file 1Password.env --out-file .env
```

If you aren't using 1Password, you could just create a `.env` file with the contents of the `1Password.env` file.

Rails will then load the environment variables from the `.env` file on startup
thanks to the `dotenv` gem.
