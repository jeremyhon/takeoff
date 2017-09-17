# versioning
VERSION    := $(shell git describe --abbrev=0 --tags)
DOCKER_TAG := $(DOCKER_TAG)
GIT_BRANCH := $(subst /,-,$(shell git rev-parse --abbrev-ref HEAD))
PKG        := github.com/jeremy/takeoff

ifeq ($(DOCKER_TAG),)
	DOCKER_TAG = "registry.scriptrock.org/jeremy/takeoff:$(GIT_BRANCH)"
endif

# DOCKER COMPOSE
.PHONY: build
build:
	docker-compose -f docker/docker-compose.dev.yml build

.PHONY: up
up:
	docker-compose -f docker/docker-compose.dev.yml up

.PHONY: stop
stop:
	docker-compose -f docker/docker-compose.dev.yml stop

.PHONY: down
down:
	docker-compose -f docker/docker-compose.dev.yml down

# TESTING TARGETS
# ------------------------------------------------------------------------------
all-tests: unit-tests go-vet gocyclo

.PHONY: unit-tests
unit-tests:
	# @echo "running unit tests"
	# @go test -race -v $(shell glide novendor)

# DOCKER TARGETS
# ------------------------------------------------------------------------------
# .PHONY: docker-build
# docker-build: charts
# 	@echo "building armada $(VERSION) docker container"
# 	@echo "$(DOCKER_TAG)"
# 	@docker build \
# 		-t armada-build \
# 		-f rootfs/build.dockerfile .
# 	@$(CURDIR)/scripts/docker-build-transfer.sh
# 	@docker build -t $(DOCKER_TAG) $(CURDIR)/rootfs
#
# .PHONY: docker-push
# docker-push:
# 	@docker push $(DOCKER_TAG)

# CLEAN TARGETS
# ------------------------------------------------------------------------------
# clean up the workspace
.PHONY: clean-images
clean-images:
	@echo "stopping and cleaning up docker images"
	docker-compose -f docker/docker-compose.dev.yml down --rmi all

.PHONY: clean
clean:
	@echo "cleaning up node modules"
	@rm -rf app/node_modules
	@rm -rf api/node_modules

.PHONY: spotless
spotless: clean clean-images
