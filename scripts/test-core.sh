#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if command -v swift >/dev/null 2>&1; then
    swift test --jobs 4
else
    # Uses the managed local daemon; may require the execution tool's sandbox escalation.
    env -u DOCKER_HOST -u DOCKER_CONTEXT -u DOCKER_TLS -u DOCKER_TLS_VERIFY -u DOCKER_CERT_PATH \
      docker --host=unix:///var/run/docker.sock run --rm \
      -v "$PWD:/app" -w /app \
      swift:6.0.3-jammy@sha256:95f6ef898992dc840b35517e780f6f6db9661432775ab0b33cc0a531ea749bdb \
      swift test --jobs 4
fi
