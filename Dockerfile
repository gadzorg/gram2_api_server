FROM ruby:2.2
MAINTAINER roots@asso.gadz.org

RUN mkdir /appli

COPY . /appli/

RUN gem install bundler -v 1.11.2 && \
    cd /appli && \ 
    bundle install --jobs=3 --retry=3 --deployment --without developpement

WORKDIR /appli

RUN gem install puma

EXPOSE 3000

env RABBITMQ_HOST=rabbitmq
env RABBITMQ_PORT=5672
env RABBITMQ_VHOST=/
env RABBITMQ_USER=gram2_api_server
env RABBITMQ_PASSWORD=gram2_api_server

CMD ["puma", "-p", "3000", "--environment", "production"]
