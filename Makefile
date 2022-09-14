SHELL                     := bash
APP_NAME                  := hello-steampipe
DOCKER_USER               := dougapd


build:
	docker build -t $(DOCKER_USER)/$(APP_NAME)

deploy-rqs:
	copilot init --app $(APP_NAME) \
  	--name $(APP_NAME) \
  	--type "Request-Driven Web Service" \
  	--dockerfile "./Dockerfile" \
  	--deploy


delete:
	copilot app delete

docker-push:
	docker push $(DOCKER_USER)/$(APP_NAME)

local:
	docker run --rm -ti -p 8080:8080 $(DOCKER_USER)/$(APP_NAME)

dashboard:
	steampipe dashboard

deps:
	brew install aws/tap/copilot-cli
	brew install steampipe
