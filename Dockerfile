############# builder            #############
FROM golang:1.13.15 AS builder

WORKDIR /go/src/github.com/gardener/cloud-provider-aws
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install \
  -mod=vendor \
  ./...

############# cloud-provider-aws #############
FROM alpine:3.13.5 AS cloud-provider-aws

COPY --from=builder /go/bin/aws-cloud-controller-manager /aws-cloud-controller-manager

WORKDIR /

ENTRYPOINT ["/aws-cloud-controller-manager"]
