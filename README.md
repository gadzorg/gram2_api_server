# GrAM v2 API Server

[![Build Status](https://travis-ci.org/gadzorg/gram2_api_server.svg?branch=master)](https://travis-ci.org/gadzorg/gram2_api_server) [![Code Climate](https://codeclimate.com/github/gadzorg/gram2_api_server/badges/gpa.svg)](https://codeclimate.com/github/gadzorg/gram2_api_server) [![Test Coverage](https://codeclimate.com/github/gadzorg/gram2_api_server/badges/coverage.svg)](https://codeclimate.com/github/gadzorg/gram2_api_server/coverage)

## Description
TODO
## Environment
Ruby : > 2 (tested with 2.2.1p85)
   
###Dependencies
Todo : rabbitMQ + config

## Configuration
TODO : Create config template
## Database initialization
For development :
```
RAILS_ENV=development rake db:migrate
```
For production :
```
RAILS_ENV=production rake db:migrate
```

## Environment variables :

 * RABBITMQ_SENDER_ID : Sender id. "gram" if not defined
 * RABBITMQ_HOST
 * RABBITMQ_PORT
 * RABBITMQ_VHOST
 * RABBITMQ_USER
 * RABBITMQ_PASSWORD
 * RABBITMQ_EXCHANGE : "agoram_event_exchange" if not defined

## Test

Prepare test MasterData with : 
```
RAILS_ENV=test rake db:migrate
```

Rspec : 
```
rspec --format doc
```

Test from RAML :
```
rake spec:vigia

```
## Deployment instructions
TODO