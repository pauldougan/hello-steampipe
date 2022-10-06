AWS_PROFILE               := paas-experiments-admin
GDS_CLI                   := gds
ASSUME_ROLE               := $(GDS_CLI) aws $(AWS_PROFILE) --   
DOMAIN                    := experiments.cloudpipeline.digital
DRAWIO                    := /Applications/draw.io.app/Contents/MacOS/draw.io
SHELL                     := bash
APP_NAME                  := hello-steampipe
DASHBOARD_SERVICE_NAME    := dashboard
NGINX_SERVICE_NAME        := mynginx3
DOCKER_USER               := dougapd
DIR                       := $(shell pwd)

build:
	docker build -t $(DASHBOARD_SERVICE_NAME) steampipe
	docker build -t $(NGINX_SERVICE_NAME) nginx

env:
	$(ASSUME_ROLE) copilot env ls

init-request-driven-web-service: Dockerfile
	$(ASSUME_ROLE) \
	copilot app init --app $(APP_NAME) \
  	--name $(SERVICE_NAME) \
  	--dockerfile "./Dockerfile" \
	--port 8080 

init-load-balanced-web-service: Dockerfile
	$(ASSUME_ROLE) \
	copilot init \
	--app $(APP_NAME) \
  	--name $(SERVICE_NAME) \
  	--type "Load Balanced Web Service" \
	--port 8080 \
  	--dockerfile "./Dockerfile" 

init-back-end-service: Dockerfile
	$(ASSUME_ROLE) \
	copilot init \
	--app $(APP_NAME) \
  	--name $(SERVICE_NAME) \
  	--type "Backend Service" \
	--port 8080 \
  	--dockerfile "./Dockerfile" 

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
	docker push $(DOCKER_USER)/$(DASHBOARD_SERVICE_NAME )

dashboard-run:
	docker run --rm -ti -p 8080:8080 $(DASHBOARD_SERVICE_NAME)

aws-console:
	gds aws paas-experiments-admin -l

aws-shell:
	$(ASSUME_ROLE) $(SHELL)

deps:
	brew install aws/tap/copilot-cli
	brew install steampipe

pull:
	docker pull nginx
	docker pull turbot/steampipe

frontend-run-noconfig:
	@echo "http://localhost:8080"
	docker run --name mynginx1 --rm -ti -p 8080:80 nginx

frontend-run-mountconfig:
	@echo "http://localhost:8081"
	docker run --name mynginx2 -v $(DIR)/nginx/www:/usr/share/nginx/html -p 8081:80 nginx

frontend-run-dockerized:
	@echo "http://localhost:8082"
	docker run --name mynginx3  -p 8082:80 mynginx3

count-vpcs:
	steampipe query "select count(*) from aws_vpc where region = 'eu-west-2'"

aws-data:
	steampipe query "select * from aws_vpc" --output csv > data/vpc.csv
	steampipe query "select * from aws_ecs_cluster" --output csv > data/ecs_cluster.csv
	steampipe query "select * from aws_ecs_service" --output csv > data/ecs_service.csv
	steampipe query "select * from aws_ecs_task" --output csv > data/ecs_task.csv
	steampipe query "select * from aws_ecs_container_instance" --output csv > data/ecs_container_instance.csv
	steampipe query "select * from aws_ecr_repository" --output csv > data/ecr_repository.csv
	steampipe query "select * from aws_ecr_image" --output csv > data/ecr_image.csv
