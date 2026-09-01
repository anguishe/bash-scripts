#!/bin/bash
# Explained line-by-line: https://bashsnippets.xyz/snippets/bash-curl-api-requests
# Script: api-request.sh
# Purpose: Call an HTTP API and FAIL when the API fails — curl exits 0 on HTTP 500 by default, which silently poisons everything downstream
# Usage: ./api-request.sh <url>
set -euo pipefail

CHECK="✓"
CROSS="✗"

API_URL="${1:?Usage: api-request.sh <url>}"
CONNECT_TIMEOUT=5   # seconds allowed to establish the TCP connection
MAX_TIME=30         # hard ceiling on the whole request so cron can't wedge
MAX_RETRIES=3       # transient 5xx/429 get retried; other 4xx does not
RETRY_DELAY=2       # seconds between retries

api_get() {
  local url="$1"
  local attempt=1
  local response http_code body

  while (( attempt <= MAX_RETRIES )); do
    # -w appends the status code on its own line after the body, so we can split them.
    # The || guards the transport-level failures (DNS, refused, timeout) that DO set curl's exit code.
    if ! response=$(curl -sS \
          --connect-timeout "$CONNECT_TIMEOUT" \
          --max-time "$MAX_TIME" \
          -w $'\n%{http_code}' \
          "$url"); then
      echo "$CROSS transport error on attempt $attempt/$MAX_RETRIES" >&2
      attempt=$(( attempt + 1 )); sleep "$RETRY_DELAY"; continue
    fi

    http_code="${response##*$'\n'}"   # last line is the status code
    body="${response%$'\n'*}"         # everything before it is the body

    case "$http_code" in
      2*)
        printf '%s' "$body"
        echo "$CHECK $http_code OK" >&2
        return 0
        ;;
      429|5*)
        echo "$CROSS $http_code (attempt $attempt/$MAX_RETRIES) — retrying" >&2
        attempt=$(( attempt + 1 )); sleep "$RETRY_DELAY"
        ;;
      *)
        echo "$CROSS $http_code — not retryable, this is our request" >&2
        echo "$body" >&2
        return 1
        ;;
    esac
  done

  echo "$CROSS gave up after $MAX_RETRIES attempts" >&2
  return 1
}

api_get "$API_URL"
