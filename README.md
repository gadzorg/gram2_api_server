# GrAM v2 API Server

[![Build Status](https://travis-ci.org/gadzorg/gram2_api_server.svg?branch=master)](https://travis-ci.org/gadzorg/gram2_api_server) [![Code Climate](https://codeclimate.com/github/gadzorg/gram2_api_server/badges/gpa.svg)](https://codeclimate.com/github/gadzorg/gram2_api_server) [![Test Coverage](https://codeclimate.com/github/gadzorg/gram2_api_server/badges/coverage.svg)](https://codeclimate.com/github/gadzorg/gram2_api_server/coverage)

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

 - Ruby version

 - System dependencies

 - Configuration

 - Database creation

 - Database initialization

 - How to run the test suite

 - Services (job queues, cache servers, search engines, etc.)

 - Deployment instructions

 - ...

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
RAILS_ENV=test rake master_data:db:migrate
```

Rspec : 
```
rspec --format doc
```

Test from RAML :
```
rake spec:vigia
```
