ARG GO_VERSION=1.22.2

# Build the executable
FROM golang:${GO_VERSION}-alpine as builder

RUN addgroup -S colorapp && \
    adduser -G colorapp -S colorapp

WORKDIR /usr/src/colorapp

COPY . .

RUN go mod download && go mod verify

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -v -o /usr/local/bin/colorapp

# Build the final container
FROM scratch AS final

LABEL maintainer="bapturp"

COPY --from=builder /usr/local/bin/colorapp /colorapp

COPY --from=builder /etc/passwd /etc/passwd

USER colorapp

EXPOSE 8080

ENTRYPOINT ["/colorapp"]
