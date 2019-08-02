FROM alpine:latest as builder

RUN apk add --no-cache git bash openssh-client protobuf \
 && mkdir /root/.ssh \
 && chmod 0700 /root/.ssh \
 && ssh-keyscan github.com > ~/.ssh/known_hosts \
 && git clone --depth=1 https://github.com/googleapis/googleapis /workspace/proto
 
WORKDIR /workspace
 
COPY ./codecamp ./proto/codecamp

RUN protoc \
      -I ./proto \
      --descriptor_set_out=proto.pb \
      proto/codecamp/**/*.proto

FROM istio/proxyv2:1.2.3

COPY --from=builder /workspace/proto.pb /etc/envoy/proto.pb
