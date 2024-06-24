
DOCKER_CMD = podman ## podman or docker
DOCKER_OPT =        ## default: empty, "--security-opt label=disable"
OAGEN_CLI = $(DOCKER_CMD) run $(DOCKER_OPT) --rm -v "${PWD}:/local" docker.io/openapitools/openapi-generator-cli:latest

.PHONY: manual gen-docs gen-code validate clean diff-files

manual:
	firefox "https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.3.md"

gen-docs:
	$(OAGEN_CLI) generate -g html -o /local/docs -i /local/openapi.yaml

gen-code:
	$(OAGEN_CLI) generate -g ruby-sinatra -o /local/code -i /local/openapi.yaml
	cp _docker/default_api.rb code/api/
	cp _docker/Makefile code/
	cp _docker/Dockerfile code/
	cp _docker/run.sh code/
	cp _docker/Gemfile code/
	cp _docker/config.ru code/
	cp _docker/my_app.rb code/
	cp _docker/mysolr.rb code/lib/
	cp _docker/myutil.rb code/lib/
	cp _docker/dataapi.rb code/lib/
	cp _docker/deeplapi.rb code/lib/
	cp _docker/gct.rb code/lib/
	cp _docker/ats.rb code/lib/
	cp _docker/gct-key.json code/

## Please install the command as following: $ pip3 install openapi-spec-validator --user
validate:
	$(DOCKER_CMD) run $(DOCKER_OPT) -v `pwd`/openapi.yaml:/openapi.yaml --rm docker.io/pythonopenapi/openapi-spec-validator:latest /openapi.yaml

clean:
	find . -type f -name '*~' -exec rm {} \; -print

diff-files:
	diff -u _docker/default_api.rb code/api/default_api.rb
	@echo diff -u _docker/Makefile code/Makefile
	diff -u _docker/Dockerfile code/Dockerfile
	diff -u _docker/run.sh code/run.sh
	diff -u _docker/Gemfile code/Gemfile
	diff -u _docker/config.ru code/config.ru
	diff -u _docker/my_app.rb code/my_app.rb
	diff -u _docker/mysolr.rb code/lib/mysolr.rb
	diff -u _docker/myutil.rb code/lib/myutil.rb
	diff -u _docker/dataapi.rb code/lib/dataapi.rb
	diff -u _docker/deeplapi.rb code/lib/deeplapi.rb
	diff -u _docker/gct.rb code/lib/gct.rb
	diff -u _docker/ats.rb code/lib/ats.rb

solr-run:
	sudo docker run -it --rm -d \
		-p 8983:8983 \
		-v `pwd`/var.solr:/var/solr \
		--name solr \
		solr:8.7

solr-stop:
	sudo docker stop solr
