all: build
push: push
.PHONY: push build

# To bump the Zeppelin version, bump the version in
# zeppelin/Dockerfile and bump this tag and reset to v1.
TAG = 1.0.4
PROJECT_NAME = twitter-tracker

build: main ca-certificates.crt
	docker build -t projectepic/$(PROJECT_NAME) .
	docker tag projectepic/$(PROJECT_NAME) projectepic/$(PROJECT_NAME):$(TAG)

push: build
	docker push projectepic/$(PROJECT_NAME)
	docker push projectepic/$(PROJECT_NAME):$(TAG)

main: twitter2kafka.go
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main twitter2kafka.go

mainmac: twitter2kafka.go
	CGO_ENABLED=0 GOOS=darwin go build -a -installsuffix cgo -o mainmac twitter2kafka.go

ca-certificates.crt:
	curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
	mv cacert.pem ca-certificates.crt

clean:
	docker rmi projectepic/$(PROJECT_NAME):$(TAG) || :
	docker rmi projectepic/$(PROJECT_NAME) || :
	rm ca-certificates.crt
	rm main

