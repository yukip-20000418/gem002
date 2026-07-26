# 1. Go のビルド環境
FROM golang:1.26-alpine
WORKDIR /app
COPY back/go.mod ./
RUN go mod download
COPY back/ ./
RUN CGO_ENABLED=0 GOOS=linux go build -o server main.go

# 2. 実行用コンテナ
FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /app

# ビルドした Go バイナリをコピー
COPY --from=0 /app/server .

# Flutter Web のビルド成果物をコピー
COPY front/build/web ./web

# Cloud Run が指定するポート（8080）で起動
EXPOSE 8080
CMD ["./server"]
