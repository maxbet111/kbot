# Етап 1: builder (збираємо код)
FROM quay.io/projectquay/golang:1.22 AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /go/src/app
COPY . .

# Проганяємо тести перед збіркою
RUN go test -v ./...

# Крос-компілюємо бінарний файл без CGO
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot .

# Етап 2: фінальний мінімальний образ
# Використовуємо alpine замість scratch
FROM alpine:latest

# Встановлюємо сертифікати (тут apk спрацює, бо це alpine!)
RUN apk add -U --no-cache ca-certificates

# Правильний шлях без пробілу
WORKDIR /app

# Копіюємо ТІЛЬКИ готовий файл бота з першого етапу
COPY --from=builder /go/src/app/kbot /app/kbot

ENTRYPOINT ["/app/kbot"]