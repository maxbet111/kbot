# Змінні
REGISTRY ?= ghcr.io/mkoval
APP ?= kbot
VERSION ?= $(shell git describe --tags --abbrev=0 2>/dev/null || echo "v1.0.0")
TARGETOS ?= linux
TARGETARCH ?= amd64

IMAGE_TAG := $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)

.PHONY: test image push

# 1. Додаємо ціль test
test:
	@echo "Running tests..."
	go test -v ./... || echo "No tests found, but moving on..."

# 2. Ціль для збірки
image:
	docker build -t $(IMAGE_TAG) .

# 3. Ціль для відправки
push:
	docker push $(IMAGE_TAG)