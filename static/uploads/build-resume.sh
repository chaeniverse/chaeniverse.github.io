#!/bin/bash
# Convert resume.html → resume.pdf using Chrome headless.
# Usage: ./build-resume.sh   (run from this directory, or use absolute paths)

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
INPUT="$DIR/resume.html"
OUTPUT="$DIR/resume.pdf"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ ! -x "$CHROME" ]; then
  echo "Error: Google Chrome not found at $CHROME"
  exit 1
fi

if [ ! -f "$INPUT" ]; then
  echo "Error: $INPUT not found"
  exit 1
fi

echo "Converting: $INPUT  →  $OUTPUT"
"$CHROME" \
  --headless=new \
  --disable-gpu \
  --no-pdf-header-footer \
  --print-to-pdf="$OUTPUT" \
  "file://$INPUT" 2>&1 | grep -v "^$" || true

echo "Done: $OUTPUT"
ls -lh "$OUTPUT"
