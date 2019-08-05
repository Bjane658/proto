FROM alpine:latest

RUN apk add --no-cache git bash openssh-client protobuf \
 && mkdir /root/.ssh \
 && chmod 0700 /root/.ssh \
 && ssh-keyscan github.com > ~/.ssh/known_hosts \
 && git clone --depth=1 https://github.com/googleapis/googleapis /workspace/proto \
 && git clone --depth=1 -b v3.8.0 https://github.com/protocolbuffers/protobuf.git /workspace/protobuf
