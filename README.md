# GrAM v2 API Server

[![Build Status](https://travis-ci.org/gadzorg/gram2_api_server.svg?branch=master)](https://travis-ci.org/gadzorg/gram2_api_server) [![Code Climate](https://codeclimate.com/github/gadzorg/gram2_api_server/badges/gpa.svg)](https://codeclimate.com/github/gadzorg/gram2_api_server) [![Test Coverage](https://codeclimate.com/github/gadzorg/gram2_api_server/badges/coverage.svg)](https://codeclimate.com/github/gadzorg/gram2_api_server/coverage)

## Description
TODO
## Environment
Ruby : > 2 (tested with 2.2.1p85)
   
###Dependencies
#### RabbitMQ
You can setup a local rabbitMQ instance with docker and default configuration
```
docker run  --name gram-rabbitmq -p 5672:5672 rabbitmq
```

## Configuration
Create `secrets.yml`, `database.yml` and optionally `rabbitmq.yml` from the templates files in `config` dir.
The rabbitmq template contains the default configuration for a local rabbitMQ server setup with docker.
## Database initialization
For development :
```
RAILS_ENV=development rake db:migrate:reset
RAILS_ENV=development rake db:seed
```
For production :
```
RAILS_ENV=production rake db:migrate:reset
RAILS_ENV=production rake db:seed
```
## Environment variables :

 * RABBITMQ_SENDER_ID : Sender id. "gram" if not defined
 * RABBITMQ_HOST
 * RABBITMQ_PORT
 * RABBITMQ_VHOST
 * RABBITMQ_USER
 * RABBITMQ_PASSWORD
 * RABBITMQ_EXCHANGE : "agoram_event_exchange" if not defined
 
 Your can override these variables if you configure `confi/rabbitmq.yml`

## Test

Prepare test MasterData with : 
```
RAILS_ENV=test rake db:migrate
```

Rspec : 
```
rspec --format doc
```

## Deployment instructions
TODO