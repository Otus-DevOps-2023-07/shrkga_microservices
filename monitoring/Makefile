.DEFAULT_GOAL := help
SRC_PATH := ../src
MON_PATH := ../monitoring
USER_NAME := $(shell awk -F'=' '/USERNAME/ { print $$2 }' ${SRC_PATH}/.env)
THIS_FILE := $(lastword $(MAKEFILE_LIST))
export USER_NAME

.PHONY: help
help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(THIS_FILE) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: docker-login
docker-login:
	docker login -u ${USER_NAME}

.PHONY: build-all
build-all: build-ui build-comment build-post build-prometheus build-blackbox ## Build all images

.PHONY: build-ui
build-ui: ${SRC_PATH}/ui/docker_build.sh ${SRC_PATH}/ui/Dockerfile ## Build UI image
	cd ${SRC_PATH}/ui && bash docker_build.sh && cd -

.PHONY: build-comment
build-comment: ${SRC_PATH}/comment/docker_build.sh ${SRC_PATH}/comment/Dockerfile ## Build Comment image
	cd ${SRC_PATH}/comment && bash docker_build.sh && cd -

.PHONY: build-post
build-post: ${SRC_PATH}/post-py/docker_build.sh ${SRC_PATH}/post-py/Dockerfile ## Build Post image
	cd ${SRC_PATH}/post-py && bash docker_build.sh && cd -

.PHONY: build-blackbox
build-blackbox: ${MON_PATH}/blackbox/Dockerfile ${MON_PATH}/blackbox/config.yml ## Build Blackbox exporter image
	docker build -t ${USER_NAME}/blackbox-exporter ${MON_PATH}/blackbox/

.PHONY: build-prometheus
build-prometheus: ${MON_PATH}/prometheus/Dockerfile ${MON_PATH}/prometheus/prometheus.yml ## Build Prometheus exporter image
	docker build -t ${USER_NAME}/prometheus ${MON_PATH}/prometheus/

.PHONY: push-all
push-all: push-ui push-comment push-post push-prometheus push-blackbox ## Push all images to Docker Hub

.PHONY: push-ui
push-ui: docker-login ## Push UI image to Docker Hub
	docker push ${USER_NAME}/ui

.PHONY: push-comment
push-comment: docker-login ## Push Comment image to Docker Hub
	docker push ${USER_NAME}/comment

.PHONY: push-post
push-post: docker-login ## Push Post image to Docker Hub
	docker push ${USER_NAME}/post

.PHONY: push-blackbox
push-blackbox: docker-login ## Push Blackbox exporter image to Docker Hub
	docker push ${USER_NAME}/blackbox-exporter

.PHONY: push-prometheus
push-prometheus: docker-login ## Push Prometheus image to Docker Hub
	docker push ${USER_NAME}/prometheus
