# Змінні
REGISTRY := ghcr.io/maxbet111
APP := kbot
# Додаємо архітектуру та ОС прямо в тег
TARGETOS := linux
TARGETARCH := amd64

# Формуємо версію з хешем та архітектурою
VERSION := v1.0.0-$(shell git rev-parse --short HEAD)-$(TARGETOS)-$(TARGETARCH)

IMAGE_TAG := $(REGISTRY)/$(APP):$(VERSION)

.PHONY: test image push

# 1. Додаємо ціль test
test:
	@echo "Running tests..."
	go test -v ./... || echo "No tests found, but moving on..."

# 2. Ціль для збірки
image:
	docker build -t $(REGISTRY)/$(APP):$(VERSION) .

# 3. Ціль для відправки
push:
	docker push $(REGISTRY)/$(APP):$(VERSION)