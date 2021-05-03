
NAME = sinatra-webapp
DOCKER_IMAGE = sinatra-webapp
DOCKER_IMAGE_VERSION = 0.1.1
IMAGE_NAME = $(DOCKER_IMAGE)
REGISTRY_SERVER = inovtst9.u-aizu.ac.jp
REGISTRY_LIBRARY = $(shell id -un)

PROTOCOL = http
HOST = 0.0.0.0
PORT = 8080
URI_PATH = search

.PHONY: run bundle-install docker-build docker-build-prod docker-tag docker-push docker-run docker-stop stop

run: bundle-install
	bundle exec rackup --host $(HOST) --port $(PORT)

bundle-install:
	bundle config set path lib
	bundle install

docker-build:
	rm -f Gemfile.lock
	rm -fr lib/ruby
	rm -fr .bundle
	sudo docker build . --tag $(IMAGE_NAME)

docker-build-prod:
	rm -f Gemfile.lock
	rm -fr lib/ruby
	rm -fr .bundle
	sudo docker build . --tag $(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) --no-cache

docker-tag:
	sudo docker tag  $(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

docker-push:
	sudo docker push $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

docker-run:
	sudo docker run -it --rm  \
		--env LC_CTYPE=ja_JP.UTF-8 \
		-p $(PORT):8080 \
		--name $(NAME) \
                $(IMAGE_NAME)

docker-stop:
	sudo docker stop $(NAME)

stop:
	killall ruby2.5

