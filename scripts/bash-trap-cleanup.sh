#!/bin/bash
# Explained line-by-line: https://bashsnippets.xyz/snippets/bash-trap-cleanup
# Script: nightly-report.sh
# Purpose: Generate a CSV without ever exposing a half-written file to
#          downstream consumers — and without littering /tmp on crashes
# Usage: ./nightly-report.sh /var/exports/report.csv
# Tested: Ubuntu 22.04 LTS, Fedora 39, macOS Ventura
set -euo pipefail

CHECK="✓"
CROSS="✗"

FINAL_PATH="${1:?usage: nightly-report.sh /path/to/output.csv}"

# mktemp gives a unique, race-free path — parallel runs can't collide,
# and nothing can pre-plant a file at a name it guessed.
TMP_FILE=$(mktemp)

cleanup() {
  # $? first, before any command overwrites it — this is the exit code
  # the script was actually dying with.
  local code=$?
  rm -f "$TMP_FILE"
  if [ "$code" -ne 0 ]; then
    echo "$CROSS failed with exit $code — temp cleaned, $FINAL_PATH untouched" >&2
  fi
  exit "$code"
}
# Registered on the line after mktemp: from this point there is no way out
# of the script that leaves the temp file behind (short of kill -9).
trap cleanup EXIT

# --- replace this with your real query/export; it must write to stdout ---
# Kept here so the script runs standalone: the pattern below is what matters,
# not the rows. Anything that writes to stdout drops straight in.
generate_report_rows() {
  echo "date,host,metric,value"
  for i in $(seq 1 60); do
    echo "$(date -I),$(hostname -s),sample_metric_${i},$(( RANDOM % 1000 ))"
  done
}

# --- the real work writes ONLY to the temp path ---
generate_report_rows > "$TMP_FILE"

# Sanity gate: refuse to publish an implausibly small file. A truncated
# output should fail loudly here, not get loaded downstream at 02:30.
MIN_BYTES=1024
if [ "$(wc -c < "$TMP_FILE")" -lt "$MIN_BYTES" ]; then
  echo "$CROSS output under ${MIN_BYTES} bytes — refusing to publish" >&2
  exit 1
fi

# mv on the same filesystem is atomic: consumers see the old complete file
# or the new complete file, never anything in between.
mv "$TMP_FILE" "$FINAL_PATH"
echo "$CHECK published $FINAL_PATH"
