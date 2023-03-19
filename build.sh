#!/bin/bash
podman build -t text-generation-webui  --security-opt label=type:nvidia_container_t --hooks-dir /usr/share/containers/oci/hooks.d/ -f Containerfile
