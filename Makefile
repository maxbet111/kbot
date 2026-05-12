# Вкажи свій нікнейм на GitHub замість <your-github-user>
REGISTRY ?= ghcr.io/<your-github-user>
APP ?= kbot
# Версія може братися з git або бути статичною
VERSION ?= $(shell git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")
TARGETOS ?= linux
TARGETARCH ?= amd64

IMAGE_TAG := $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)

# ... інші цілі ...

image:
	docker build -t $(IMAGE_TAG) .

push:
	docker push $(IMAGE_TAG)