# Використовуємо вказаний базовий образ
FROM quay.io/projectquay/golang:1.22 as builder

# Аргументи, які Docker підставляє автоматично при multi-platform збірці 
# або які ми передаємо через Makefile
ARG TARGETOS
ARG TARGETARCH

WORKDIR /go/src/app
COPY . .

# Проганяємо тести перед збіркою
RUN go test -v ./...

# Крос-компілюємо бінарний файл без CGO для стабільної роботи в мінімальних контейнерах
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot .

# Другий етап: створюємо мінімальний робочий образ
FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot /kbot

# Копіюємо сертифікати (необхідно для Telegram API)
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT ["/kbot"]