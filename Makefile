ASCIINEMA_REC             := asciinema rec --overwrite
ASCIINEMA_APPEND          := asciinema rec --append
AWS_PROFILE               := paas-experiments-admin
GDS_CLI                   := gds
ASSUME_ROLE               := $(GDS_CLI) aws $(AWS_PROFILE) --   
DOMAIN                    := govukpaasmigration.digital
DRAWIO                    := /Applications/draw.io.app/Contents/MacOS/draw.io
SHELL                     := bash
APP_NAME                  := pipe
DASHBOARD_SERVICE_NAME    := dashboard
NGINX_SERVICE_NAME        := mynginx3
DOCKER_USER               := dougapd
DIR                       := $(shell pwd)
IS_ON_VPN                 := $(shell bin/is_on_VPN)

define record_command
$(ASCIINEMA_APPEND) -c $1 casts/$2.cast
endef

menu:
	egrep -E "^[0-9]{2}" Makefile | gsed 's/://'

status:
	@copilot svc status -n dashboard
	@copilot svc status -n nginx

play:
	@find casts -type f | sort | header -a "asciinema_cast" | vd -f csv | gsed 1d | xargs -n 1 asciinema play -s 4

build:
	docker build -t $(DASHBOARD_SERVICE_NAME) steampipe
	docker build -t $(NGINX_SERVICE_NAME) nginx

env:
	$(ASSUME_ROLE) copilot env ls

edit-diagram: docs/steampipe-deploy.drawio.xml
	$(DRAWIO) $^

publish-diagram: docs/steampipe-deploy.png docs/steampipe-deploy.svg

docs/steampipe-deploy.svg: docs/steampipe-deploy.drawio.xml
	$(DRAWIO) -x -e  -o $@ $<

docs/steampipe-deploy.png: docs/steampipe-deploy.drawio.xml
	$(DRAWIO) -x -e  -o $@ $<
 	
docker-push:
	docker push $(DOCKER_USER)/$(DASHBOARD_SERVICE_NAME )

dashboard-run:
	docker run --rm -ti -p 8080:8080 $(DASHBOARD_SERVICE_NAME)

aws: aws-console aws-shell

aws-console:
	# if not on VPN throw error
	gds aws paas-experiments-admin -l

aws-shell: 
	# if not on VPN throw error
	$(ASSUME_ROLE) $(SHELL) -l

deps:
	brew install aws/tap/copilot-cli
	brew install steampipe
	steampipe plugin install aws
	steampipe plugin install csv
	steampipe plugin install github

pull:
	docker pull nginx
	docker pull turbot/steampipe

frontend-run-mountconfig:
	@echo "http://localhost:8081"
	docker run --name mynginx2 -v $(DIR)/nginx/www:/usr/share/nginx/html -p 8081:80 nginx

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

01-app-init:
	$(ASCIINEMA_REC) -c 'copilot app init $(APP_NAME) --resource-tags department=GDS,team=govuk-paas,owner=paul.dougan --domain $(DOMAIN)' 		casts/$@.cast
	
02-env-init:
	$(ASCIINEMA_REC)     -c 'copilot env init -a $(APP_NAME) -n dev --container-insights' 		casts/$@.cast

03-env-deploy:
	$(ASCIINEMA_REC)    -c 'copilot env deploy -a $(APP_NAME) -n dev' 		casts/$@.cast

04-svc-init-dashboard:
	$(ASCIINEMA_REC)    -c 'copilot svc init  -d dashboard/Dockerfile -a $(APP_NAME) -n dashboard -t "Backend Service"' casts/$@.cast

05-svc-deploy-dashboard:
	$(ASCIINEMA_REC)    -c 'copilot svc deploy -a $(APP_NAME) -e dev -n dashboard' casts/05-svc-deploy-dashboard.cast

06-svc-init-nginx:
	$(ASCIINEMA_REC)    -c 'copilot svc init -d nginx/Dockerfile.3 -a $(APP_NAME) -n nginx -t "Load Balanced Web Service"' casts/$@.cast

07-svc-deploy-nginx:
	$(ASCIINEMA_REC)    -c 'copilot svc deploy -a $(APP_NAME) -e dev -n nginx' casts/$@.cast
	
08-document-app:
	$(call record_command, "copilot app ls",$@)
	$(call record_command, "copilot app show -n $(APP_NAME)",$@)
	$(call record_command, "copilot env ls",$@)
	$(call record_command, "copilot env show -a $(APP_NAME)" -n dev",$@)
	$(call record_command, "copilot svc ls -a $(APP_NAME)",$@)
	$(call record_command, "copilot svc show -a $(APP_NAME) -n dashboard ",$@)
	$(call record_command, "copilot svc show -a $(APP_NAME) -n nginx ",$@)

09-svc-delete-nginx:
	$(ASCIINEMA_REC)    -c 'copilot svc delete -a $(APP_NAME) -e dev -n nginx' casts/$@.cast

10-svc-delete-dashboard:
	$(ASCIINEMA_REC)    -c 'copilot svc delete -a $(APP_NAME) -e dev -n dashboard' casts/$@.cast

11-app-delete-app:
	$(ASCIINEMA_REC)    -c 'copilot app delete -n $(APP_NAME)' casts/$@.cast


create-environments: 	01-app-init 02-env-init 03-env-deploy
deploy-all: 			deploy-dashboard deploy-nginx
deploy-dashboard: 		04-svc-init-dashboard 05-svc-deploy-dashboard
deploy-nginx: 			06-svc-init-nginx 07-svc-deploy-nginx
delete-all: 			11-app-delete-app

check_VPN:
	@echo "VPN_status: $(IS_ON_VPN)"
