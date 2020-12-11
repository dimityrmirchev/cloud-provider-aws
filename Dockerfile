############# builder            #############
FROM eu.gcr.io/gardener-project/3rd/golang:1.15.5 AS builder

WORKDIR /go/src/github.com/gardener/cloud-provider-aws
COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install \
  -mod=vendor \
  ./...

############# base               #############
FROM eu.gcr.io/gardener-project/3rd/alpine:3.12.1 AS base

RUN apk add --update bash curl

WORKDIR /

############# cloud-provider-aws #############
FROM base AS cloud-provider-aws

COPY --from=builder /go/bin/aws-cloud-controller-manager /aws-cloud-controller-manager

ENTRYPOINT ["/aws-cloud-controller-manager"]
