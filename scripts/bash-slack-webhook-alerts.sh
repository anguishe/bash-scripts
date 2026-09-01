#!/bin/bash
# Explained line-by-line: https://bashsnippets.xyz/snippets/bash-slack-webhook-alerts
# Script: slack-alert.sh
# Purpose: Post a failure alert to Slack so a broken cron job tells you instead of failing silently for a week
# Usage: SLACK_WEBHOOK_URL=... ./slack-alert.sh   (set the URL in the environment, never hardcode it)
set -euo pipefail

CHECK="✓"
CROSS="✗"

# The webhook URL is a secret — anyone who has it can post to your channel.
# Keep it in the environment or a 0600 file; never commit it.
: "${SLACK_WEBHOOK_URL:?Set SLACK_WEBHOOK_URL in the environment}"
HOST_SHORT="$(hostname -s)"

slack_alert() {
  local message="$1"
  local level="${2:-error}"        # error | warn | info
  local payload http_code

  # Build the JSON with jq so a message containing quotes, newlines, or backslashes
  # can't break the payload or inject fields. Never string-concat text into JSON.
  payload=$(jq -n \
    --arg text ":rotating_light: *${level^^}* on \`${HOST_SHORT}\`: ${message}" \
    '{text: $text}')

  # -o /dev/null discards Slack's "ok" body; -w gives us the status to check.
  http_code=$(curl -sS --max-time 10 \
    -X POST -H 'Content-Type: application/json' \
    -d "$payload" \
    -w '%{http_code}' -o /dev/null \
    "$SLACK_WEBHOOK_URL") || { echo "$CROSS could not reach Slack" >&2; return 1; }

  if [[ "$http_code" == "200" ]]; then
    echo "$CHECK alert sent"
  else
    echo "$CROSS Slack returned $http_code" >&2
    return 1
  fi
}

# Any unhandled error fires an alert with the failing line number, then the script exits.
trap 'slack_alert "script failed at line $LINENO (exit $?)"' ERR

# --- your real work goes here; if it exits non-zero, Slack hears about it ---
echo "$CHECK doing work..."
