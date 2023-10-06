
DOCKER_CMD = docker

NAME = example-transapi
DOCKER_IMAGE = example-transapi
DOCKER_IMAGE_VERSION = 1.1.0
IMAGE_NAME = $(DOCKER_IMAGE)
REGISTRY_SERVER = docker.io
REGISTRY_LIBRARY = yasuhiroabe

PROTOCOL = http
HOST = 0.0.0.0
PORT = 8080
URI_PATH = search

.PHONY: run bundle-install docker-build docker-build-prod docker-tag docker-push docker-run docker-stop stop

run: bundle-install
	env GOOGLE_APPLICATION_CREDENTIALS="$$(pwd)/gct-key.json" \
		GOOGLE_PROJECT_ID="uoatranslationproject" \
		DEEPL_HOST="api.deepl.com" \
		DEEPL_AUTHKEY="e9d941d1-3d32-36ab-3a6b-d42dc0979af9" \
		MSATS_KEY="efd9c5c3df344761b41f7f9ae4714bbe" \
		bundle exec rackup --host $(HOST) --port $(PORT)

bundle-install:
	bundle config set path lib
	bundle install

docker-build:
	rm -f Gemfile.lock
	rm -fr lib/ruby
	rm -fr .bundle
	$(DOCKER_CMD) build . --pull --tag $(IMAGE_NAME)

docker-build-prod:
	rm -f Gemfile.lock
	rm -fr lib/ruby
	rm -fr .bundle
	$(DOCKER_CMD) build . --pull --tag $(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) --no-cache

docker-tag:
	$(DOCKER_CMD) tag  $(IMAGE_NAME):$(DOCKER_IMAGE_VERSION) $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

docker-push:
	$(DOCKER_CMD) push $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

docker-run:
	$(DOCKER_CMD) run -it --rm  \
		--volume $$(pwd)/gct-key.json:/gct-key.json \
		--env LC_CTYPE=ja_JP.UTF-8 \
		--env GOOGLE_APPLICATION_CREDENTIALS="/gct-key.json" \
		--env GOOGLE_PROJECT_ID="uoatranslationproject" \
		--env DEEPL_HOST="api.deepl.com" \
		--env DEEPL_AUTHKEY="935fd9cd-7d5f-8ad9-3628-96f042794751" \
		--env SOLR_URI="http://10.1.1.1:8983/solr/solrbook" \
		-p $(PORT):8080 \
		--name $(NAME) \
		$(IMAGE_NAME)

docker-stop:
	$(DOCKER_CMD) stop $(NAME)

