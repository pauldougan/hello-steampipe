SHELL                     := bash
APP_NAME                  := hello-steampipe
DOCKER_USER               := dougapd

build:
	docker build -t $(DOCKER_USER)/$(APP_NAME)

docker-push:
	docker push $(DOCKER_USER)/$(APP_NAME)

local:
	docker run --rm -ti -p 8080:8080 $(DOCKER_USER)/$(APP_NAME) --dashboard-port 8080 --browser=false --dashboard-listen network

local2:
	docker run --rm -ti -p 8080:8080 $(DOCKER_USER)/$(APP_NAME)

deps:
	brew install aws/tap/copilot-cli
	brew install steampipe
