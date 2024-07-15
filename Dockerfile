FROM golang:1.22.5 as builder
WORKDIR /code
COPY src/ .

# `skaffold debug` sets SKAFFOLD_GO_GCFLAGS to disable compiler optimizations
RUN go build -trimpath -o /app main.go

FROM debian
# Define GOTRACEBACK to mark this container as using the Go language runtime
# for `skaffold debug` (https://skaffold.dev/docs/workflows/debug/).
ENV GOTRACEBACK=single

RUN mkdir /app
COPY --from=builder /app /app/ping

USER 158136
WORKDIR /app
CMD ["./ping"]