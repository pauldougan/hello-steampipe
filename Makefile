AWS_PROFILE               := paas-experiments-admin
GDS_CLI                   := gds
ASSUME_ROLE               := $(GDS_CLI) aws $(AWS_PROFILE) --   
DRAWIO                    := /Applications/draw.io.app/Contents/MacOS/draw.io
SHELL                     := bash
APP_NAME                  := hello-steampipe
SERVICE_NAME              := dashboard
DOCKER_USER               := dougapd


build:
	docker build -t $(APP_NAME) .

env:
	$(ASSUME_ROLE) copilot env ls

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

edit-diagram: docs/steampipe-deploy.drawio.xml
	$(DRAWIO) $^


publish-diagram: docs/steampipe-deploy.png docs/steampipe-deploy.svg

docs/steampipe-deploy.svg: docs/steampipe-deploy.drawio.xml
	$(DRAWIO) -x -e  -o $@ $<

docs/steampipe-deploy.png: docs/steampipe-deploy.drawio.xml
	$(DRAWIO) -x -e  -o $@ $<
 	
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

aws-console:
	gds aws paas-experiments-admin -l

aws-shell:
	$(ASSUME_ROLE) $(SHELL)
deps:
	brew install aws/tap/copilot-cli
	brew install steampipe
