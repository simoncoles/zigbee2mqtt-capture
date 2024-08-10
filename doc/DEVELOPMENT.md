## Development

You can just open this in VSCode and start the DevContainer.

### Secrets

The tricky bit is secrets because you'll want to connect to your MQTT broker. 

I use 1Password for my secrets, so I have a `1Password.env` file that I source to set the environment variables. When I create a new DevContainer, I need to inject the secrets from 1Password into the `.env` file.

```shell
export OP_SERVICE_ACCOUNT_TOKEN=<enter token here>

op inject --in-file 1Password.env --out-file .env
```

If you aren't using 1Password, you could just create a `.env` file with the contents of the `1Password.env` file.

Rails will then load the environment variables from the `.env` file on startup
thanks to the `dotenv` gem.

### Running the Capture

In production, the capture is run as a background thread, but in development, you need to run it from the command line.

``` shell
rails runner MqttMessage.connect
```

