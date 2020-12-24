FROM --platform=$BUILDPLATFORM golang:1.15 AS build
LABEL maintainer="Jay Ovalle <jay.ovalle@gmail.com>"
ARG TARGETARCH
ENV GOARCH=$TARGETARCH
RUN git clone https://github.com/jovalle/nfs-client-provisioner \
  /go/src/github.com/jovalle/nfs-client-provisioner
WORKDIR /go/src/github.com/jovalle/nfs-client-provisioner
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' \
  -o /go/src/github.com/jovalle/nfs-client-provisioner/nfs-client-provisioner \
  ./cmd/nfs-client-provisioner

FROM --platform=$BUILDPLATFORM alpine:3.12
LABEL maintainer="Jay Ovalle <jay.ovalle@gmail.com>"
RUN apk update --no-cache && apk add ca-certificates
COPY --from=build /go/src/github.com/jovalle/nfs-client-provisioner/nfs-client-provisioner /usr/bin/nfs-client-provisioner
ENTRYPOINT ["/usr/bin/nfs-client-provisioner"]
