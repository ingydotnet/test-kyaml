M := .cache/makes
$(shell [ -d $M ] || git clone -q https://github.com/makeplus/makes $M)
include $M/init.mk
include $M/clean.mk

ID := kyaml-test-server
TMP := /tmp/$(ID)
HIST := $(TMP)/.bash_history

export YSPATH := $(ROOT)/lib

test := ./test/*.ys


default::

.PHONY: test
ifeq (,$(wildcard /ready))
test: start
	docker exec -it $(ID) make $@ test=$(test)
else
test:
	prove -v $(test)
endif

shell: start
	docker exec -it $(ID) bash -i

status:
	docker ps | grep $(ID) || true

stop:
	-docker kill $(ID)

chown:
	sudo chown -R $$(id -u):$$(id -g) $(ROOT)

build:
	@[[ $$(docker images | grep $(ID)) ]] || ( \
	  echo "Building base docker image"; \
	  docker build --tag=$(ID) . ; \
	)

remove: stop
	sleep 1
	docker rmi $(ID)

start: build
	@mkdir -p $(TMP)
	@touch $(HIST)
	@[[ $$(docker ps | grep $(ID)) ]] || ( \
	  echo "Starting docker container '$(ID)'..."; \
	  docker run --rm -dit \
	    -v $(ROOT):/work \
	    -v $(HIST):/root/.bash_history \
	    -w /work \
	    --name=$(ID) \
	    $(ID) \
	    bash -c ' \
	      git clone \
	        --depth=1 \
	        --branch=kyaml \
	        https://github.com/thockin/kubernetes \
		/kubernetes && \
	      cd /kubernetes && \
	      go build yaml_renderer.go && \
	      mv yaml_renderer /bin/ && \
	      touch /ready && \
	      sleep infinity' > /dev/null; \
	  echo "It usually takes about 30-60 seconds until ready."; \
	  while docker exec -it $(ID) bash -c '[[ ! -e /ready ]]'; do \
	    echo "Waiting for docker container '$(ID)' to be ready..."; \
	    sleep 10; \
	  done; \
	  echo "Docker container '$(ID)' is ready!"; \
	)
