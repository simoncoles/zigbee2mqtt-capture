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

Formatted JSON isn't nice
Consider availability e.g. zigbee2mqtt/conservatory_presence/availability
Alert of Home Assistant and Zigbee aren't connected


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
