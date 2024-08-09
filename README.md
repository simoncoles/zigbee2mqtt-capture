# README

## No authentication!

I'm using this on a private network, so there's no authentication...


## Secrets 

Are stored in 1Password. To create a local .env file with the secrets, run:

```bash
export OP_SERVICE_ACCOUNT_TOKEN=<enter token here>
op inject --in-file 1Password.env --out-file .env
```

## To do

I have many few Zigbee devices than I think I do

Not all fields are coming through to the device
In device details Link back to http://192.168.2.3:8080/#/device/0xa4c13860a8539550/info
Run in a thread rather than have a runner

Searching in Avo
Query to see if X has been seen in the last Y minutes
/seen?device=conservatory_presence&minutes=5

Sort out database password in developmnent
Deploy to production
Add link to device in Avo
Add this to messages     # add_reference :mqtt_messages, :device, null: false, foreign_key: true
Clean up avo in terms or removing thigns
Have a "Retention period" and number for each device


Formatted JSON isn't nice
Consider availability e.g. zigbee2mqtt/conservatory_presence/availability
Alert of Home Assistant and Zigbee aren't connected - do a HealthChecks.io for important things
Also listen to Home Assistant messages - what are there?
Something to cull zigbee2mqtt/conservatory_presence from the database

Add MQTT to the dev container
Create a service to send example MQTT messages which have realistic timestamps


### Readme Template

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
