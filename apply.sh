#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

docker run --rm \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    -v "${DIR}":"/out" \
    -v "${DIR}/educode":"/workspace/proto/educode" \
    educode/protobuild:1.0 \
        /bin/bash -c "protoc -I /workspace/proto \
                             -I /workspace/protobuf/src \
                             --include_imports \
                             --include_source_info \
                             --descriptor_set_out=/out/proto.pb \
                             /workspace/proto/educode/authenticator/api/v1.proto \
                             /workspace/proto/educode/catalogue/api/v1.proto \
                             /workspace/proto/educode/submission/api/v1.proto \
                             /workspace/proto/educode/review/api/v1.proto"
                        
kubectl create configmap proto-descriptor --namespace educode --from-file "${DIR}/proto.pb" -o yaml --dry-run | kubectl apply -f -
rm proto.pb
