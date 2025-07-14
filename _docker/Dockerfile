FROM ruby:3.4.3-alpine as rubydev

RUN apk update && \
    apk add --no-cache tzdata bash ca-certificates \
    	make gcc libc-dev linux-headers build-base patch

COPY . /app
WORKDIR /app

RUN bundle config set path lib
RUN bundle install

## Build runtime
FROM ruby:3.4.3-alpine

RUN apk update && \
    apk add --no-cache tzdata bash ca-certificates

COPY --from=rubydev /app /app
WORKDIR /app

ENV SINATRA_PORT 8080
ENV GOOGLE_APPLICATION_CREDENTIALS /gct-api.key
ENV GOOGLE_PROJECT_ID your-project-id
ENV DEEPL_HOST api.deepl.com
ENV DEEPL_AUTHKEY xxxxx-xxxxx-xxxxxxx-xxxxx-xxxxxx
ENV SOLR_URI http://localhost:8983/solr/solrbook
EXPOSE $SINATRA_PORT

ADD run.sh /run.sh
RUN chmod +x /run.sh

RUN addgroup sinatra
RUN adduser -S -G sinatra sinatra
USER sinatra
RUN bundle config set path lib

ENTRYPOINT ["/run.sh"]
