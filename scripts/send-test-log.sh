#!/usr/bin/env bash
set -euo pipefail

HOST="${LOGSTASH_HOST:-127.0.0.1}"
PORT="${LOGSTASH_PORT:-5000}"
SERVICE="${SERVICE_NAME:-demo-service}"
ENVIRONMENT="${ENVIRONMENT_NAME:-local}"
MESSAGE="${1:-Project 15 test log}"

printf '{"@timestamp":"%s","service":"%s","environment":"%s","message":"%s","level":"INFO"}\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$SERVICE" "$ENVIRONMENT" "$MESSAGE" \
  | nc "$HOST" "$PORT"
