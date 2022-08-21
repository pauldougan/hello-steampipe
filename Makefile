APP             := paas-dashboard

apps:
	cf apps

build:
	docker build -t dougapd/paas-dashboard  .

docker-push:
	docker push dougapd/paas-dashboard

cf-push:
	cf push

logs:
	cf logs --recent $(APP)

delete:
	cf delete -f $(APP) 

local:
	docker run --rm -ti -p 8080:8080 dougapd/paas-dashboard dashboard --dashboard-port 8080 --browser=false --dashboard-listen network

local2:
	docker run --rm -ti -p 8080:8080 dougapd/paas-dashboard

