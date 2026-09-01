#!/bin/bash
# Explained line-by-line: https://bashsnippets.xyz/snippets/bash-parse-json-jq
# Script: parse-json.sh
# Purpose: Read fields out of a JSON API response with jq — grep/cut on JSON breaks the moment the API reformats, and it fails silently
# Usage: ./parse-json.sh <owner/repo>
set -euo pipefail

CHECK="✓"
CROSS="✗"

REPO="${1:?Usage: parse-json.sh <owner/repo>}"

# Fail early and clearly on a box without jq, instead of a confusing error mid-pipeline.
command -v jq >/dev/null 2>&1 || { echo "$CROSS jq is not installed (apt install jq / brew install jq)" >&2; exit 1; }

response=$(curl -sS --max-time 30 "https://api.github.com/repos/${REPO}")

# -e sets jq's exit code from the result: non-zero when .full_name is null/absent,
# so a 404 or a rate-limit body branches here instead of returning an empty string.
# -r prints the raw value, not a quoted "string" that breaks comparisons and paths.
if ! name=$(printf '%s' "$response" | jq -er '.full_name'); then
  echo "$CROSS no repo returned (rate limited or 404?)" >&2
  exit 1
fi

# A missing key would print the literal 'null'; // supplies a real default instead.
stars=$(printf '%s' "$response" | jq -r '.stargazers_count // 0')
echo "$CHECK $name — $stars stars"

# Iterate an array field. The ? after [] keeps jq quiet if 'topics' is absent.
printf '%s' "$response" | jq -r '.topics[]? | "  - " + .'
