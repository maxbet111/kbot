APP := kbot
REGISTRY := quay.io/kbot
VERSION := $(shell git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")

# Визначаємо платформу та архітектуру хоста, на якому зараз виконується Makefile
HOSTOS := $(shell go env GOOS)
HOSTARCH := $(shell go env GOARCH)

# Формуємо тег образу
IMAGE_TAG := $(REGISTRY)/$(APP):$(VERSION)-$(HOSTOS)-$(HOSTARCH)

.PHONY: linux arm macos windows image clean

linux:
	GOOS=linux GOARCH=amd64 go build -v -o $(APP)-linux-amd64 .

arm:
	GOOS=linux GOARCH=arm64 go build -v -o $(APP)-linux-arm64 .

macos:
	GOOS=darwin GOARCH=amd64 go build -v -o $(APP)-darwin-amd64 .
	GOOS=darwin GOARCH=arm64 go build -v -o $(APP)-darwin-arm64 .

windows:
	GOOS=windows GOARCH=amd64 go build -v -o $(APP)-windows-amd64.exe .

image:
	docker build -t $(IMAGE_TAG) \
		--build-arg TARGETOS=$(HOSTOS) \
		--build-arg TARGETARCH=$(HOSTARCH) .

clean:
	rm -f $(APP)-*
	docker rmi $(IMAGE_TAG) || true