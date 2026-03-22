#!/usr/bin/env bash
# Generate a kid-friendly image using Gemini API
# Usage: generate_image.sh "prompt text" output_filename.png
# Requires: GEMINI_API_KEY environment variable

set -euo pipefail

PROMPT="${1:?Usage: generate_image.sh \"prompt\" output_file}"
OUTPUT="${2:?Usage: generate_image.sh \"prompt\" output_file}"

if [[ -z "${GEMINI_API_KEY:-}" ]]; then
  echo "Error: GEMINI_API_KEY not set. Source your .env first." >&2
  exit 1
fi

FULL_PROMPT="Generate an image: ${PROMPT}. Kid-friendly, colorful, cartoon style."
MODEL="gemini-2.5-flash-image"

echo "Generating: ${PROMPT}"
echo "Output: ${OUTPUT}"

curl -s "https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"contents\": [{\"parts\": [{\"text\": \"${FULL_PROMPT}\"}]}],
    \"generationConfig\": {\"responseModalities\": [\"IMAGE\", \"TEXT\"]}
  }" | python3 -c "
import sys, json, base64
data = json.load(sys.stdin)
candidates = data.get('candidates', [{}])
if not candidates:
    print('Error: No candidates in response', file=sys.stderr)
    print(json.dumps(data, indent=2), file=sys.stderr)
    sys.exit(1)
parts = candidates[0].get('content', {}).get('parts', [])
for part in parts:
    if 'inlineData' in part:
        img = base64.b64decode(part['inlineData']['data'])
        with open('${OUTPUT}', 'wb') as f:
            f.write(img)
        print(f'Saved {len(img)} bytes to ${OUTPUT}')
        sys.exit(0)
print('Error: No image data in response', file=sys.stderr)
sys.exit(1)
"
