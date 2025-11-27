FROM golang:1.25.4-alpine AS builder
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o ecommerce_api ./cmd

FROM gcr.io/distroless/static-debian12
COPY --from=builder /app/ecommerce_api /
EXPOSE 8080
ENTRYPOINT ["/ecommerce_api"]