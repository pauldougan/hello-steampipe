SHELL               := bash

lint: 
	nginx -t -c $$PWD/config/nginx.conf

start:
	pkill nginx || nginx -c $$PWD/config/nginx.conf

stop:
	pkill nginx

status:
	pgrep nginx

proxy0:
	docker build -t nginx-proxy0 -f Dockerfile.0 .

proxy1:
	docker build -t nginx-proxy1 -f Dockerfile.1 .

run0:
	docker run --rm -ti -p 8080:80 nginx-proxy0

run1:
	docker run --rm -ti -p 9080:9080 nginx-proxy1
