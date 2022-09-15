SHELL                     := bash
APP_NAME                  := hello-steampipe
SERVICE_NAME              := dashboard
DOCKER_USER               := dougapd


build:
	docker build -t $(APP_NAME) .

init-apprunner: Dockerfile
	copilot init --app $(APP_NAME) \
  	--name $(SERVICE_NAME) \
  	--type "Request-Driven Web Service" \
  	--dockerfile "./Dockerfile" \
	--resource-tags department=GDS,team=PaasTeam \ 

init-ecsfargate: Dockerfile
	copilot init --app $(APP_NAME) \
  	--name $(SERVICE_NAME) \
  	--type "Load Balanced Web Service" \
  	--dockerfile "./Dockerfile" \
	--resource-tags department=GDS,team=PaasTeam, owner=paul \ 
  	
deploy:
	copilot deploy

delete:
	copilot app delete

docker-push:
	docker push $(DOCKER_USER)/$(APP_NAME)

local:
	docker run --rm -ti -p 8080:8080 $(APP_NAME)

dashboard:
	steampipe dashboard

deps:
	brew install aws/tap/copilot-cli
	brew install steampipe
