#!/bin/bash
# Explained line-by-line: https://bashsnippets.xyz/snippets/bash-sed-find-replace
# Script: safe-replace.sh
# Purpose: Bulk find-and-replace that dry-runs first — because an unanchored
#          sed -i across a tree rewrites substrings you never looked at
# Usage: ./safe-replace.sh 'pattern' 'replacement' [path] [--apply]
# Tested: Ubuntu 22.04 LTS, Fedora 39, macOS Ventura
set -euo pipefail

CHECK="✓"
CROSS="✗"

PATTERN="${1:?usage: safe-replace.sh 'pattern' 'replacement' [path] [--apply]}"
REPLACEMENT="${2:?missing replacement}"
SEARCH_PATH="${3:-.}"
MODE="${4:---dry-run}"

# BSD sed (macOS) needs -i '' ; GNU sed needs bare -i. Detect once.
if sed --version >/dev/null 2>&1; then
  SED_INPLACE=(sed -i)          # GNU
else
  SED_INPLACE=(sed -i '')       # BSD/macOS
fi

# Only touch files that actually contain the pattern — everything else
# keeps its mtime, which matters for build caches and rsync.
mapfile -t FILES < <(grep -rl --exclude-dir=.git -- "$PATTERN" "$SEARCH_PATH" || true)

if [ "${#FILES[@]}" -eq 0 ]; then
  echo "$CROSS no files under $SEARCH_PATH match: $PATTERN"
  exit 1
fi

echo "$CHECK ${#FILES[@]} file(s) match"

if [ "$MODE" != "--apply" ]; then
  # Dry run: show every line that would change, change nothing.
  for f in "${FILES[@]}"; do
    echo "--- $f"
    sed "s|$PATTERN|$REPLACEMENT|g" "$f" | diff "$f" - || true
  done
  echo "$CHECK dry run only — re-run with --apply to edit in place"
  exit 0
fi

for f in "${FILES[@]}"; do
  "${SED_INPLACE[@]}" "s|$PATTERN|$REPLACEMENT|g" "$f"
  echo "$CHECK edited $f"
done
