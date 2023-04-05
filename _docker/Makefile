
NAME = example-transapi
DOCKER_IMAGE = example-transapi
DOCKER_IMAGE_VERSION = 1.1.0
IMAGE_NAME = $(DOCKER_IMAGE)
REGISTRY_SERVER = docker.io
REGISTRY_LIBRARY = yasuhiroabe

PROTOCOL = http
HOST = 0.0.0.0
PORT = 8080

.PHONY: run bundle-install docker-build docker-build-prod docker-tag docker-push docker-run docker-stop stop

run: bundle-install
	env GOOGLE_APPLICATION_CREDENTIALS="./gct-key.json" \
	    GOOGLE_PROJECT_ID="your-project-id" \
	    DEEPL_HOST="api.deepl.com" \
	    DEEPL_AUTHKEY="xxxx-xxxx-xxxx-xxxx-xxxx" \
	    MSATS_KEY="xxxxxxxxxxxx" \
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
		--volume $$(pwd)/gct-key.json:/gct-key.json \
		--env LC_CTYPE=ja_JP.UTF-8 \
		--env GOOGLE_APPLICATION_CREDENTIALS="/gct-key.json" \
		--env GOOGLE_PROJECT_ID="your-project-id" \
		--env DEEPL_HOST="api.deepl.com" \
		--env DEEPL_AUTHKEY="xxxx-xxxx-xxxx-xxxx-xxxx" \
		--env SOLR_URI="http://localhost:8983/solr/solrbook" \
		-p $(PORT):8080 \
		--name $(NAME) \
                $(IMAGE_NAME)

docker-stop:
	sudo docker stop $(NAME)

