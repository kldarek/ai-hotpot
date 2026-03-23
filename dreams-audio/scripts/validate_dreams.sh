#!/usr/bin/env bash
# validate_dreams.sh — Check dream pipeline output for a given date
# Usage: bash scripts/validate_dreams.sh [YYYY-MM-DD]
# Exit codes: 0 = all good, 1 = issues found
#
# Environment:
#   WORKSPACE — workspace root (default: parent of script dir)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE="${WORKSPACE:-$(dirname "$SCRIPT_DIR")}"

DATE="${1:-$(date +%Y-%m-%d)}"
DIR="$WORKSPACE/brain/Dreams/$DATE"
INDEX="$WORKSPACE/brain/Dreams/DREAM_INDEX.md"
ERRORS=0

echo "🔍 Validating dreams pipeline for $DATE"
echo "========================================="

# 1. Check dream folder exists
if [ ! -d "$DIR" ]; then
  echo "❌ FAIL: Dream folder $DIR does not exist"
  exit 1
fi

# 2. Check dream .md files (expect exactly 4)
MD_COUNT=$(ls "$DIR"/motivation-*.md 2>/dev/null | wc -l)
echo "📝 Dream files: $MD_COUNT/4"
if [ "$MD_COUNT" -lt 4 ]; then
  echo "❌ FAIL: Expected 4 dream .md files, found $MD_COUNT"
  ERRORS=$((ERRORS + 1))
fi

# 3. Check narrative files exist and have minimum word count
for md in "$DIR"/motivation-*.md; do
  [ -f "$md" ] || continue
  slug=$(basename "$md" .md)
  
  # Check both naming conventions
  narrative=""
  alt_slug="${slug#motivation-}"
  for candidate in "$DIR/${slug}_narrative.txt" "$DIR/${alt_slug}_narrative.txt"; do
    if [ -f "$candidate" ]; then
      narrative="$candidate"
      break
    fi
  done

  if [ -z "$narrative" ]; then
    echo "❌ FAIL: Missing narrative for $slug"
    ERRORS=$((ERRORS + 1))
  else
    words=$(wc -w < "$narrative")
    if [ "$words" -lt 400 ]; then
      echo "⚠️ WARN: Narrative for $slug only $words words (min 400)"
      ERRORS=$((ERRORS + 1))
    else
      echo "✅ Narrative $slug: $words words"
    fi
  fi
done

# 4. Check DREAM_INDEX.md has entries for today
if [ -f "$INDEX" ]; then
  INDEX_ENTRIES=$(grep -c "^- $DATE" "$INDEX" 2>/dev/null || echo 0)
  echo "📋 Index entries for $DATE: $INDEX_ENTRIES/4"
  if [ "$INDEX_ENTRIES" -lt 4 ]; then
    echo "❌ FAIL: Expected 4 index entries, found $INDEX_ENTRIES"
    ERRORS=$((ERRORS + 1))
  fi
else
  echo "⚠️ WARN: DREAM_INDEX.md not found at $INDEX"
fi

# 5. Check for topic repetition (last 7 days)
if [ -f "$INDEX" ]; then
  echo ""
  echo "🔄 Topic history (last 7 days):"
  for i in $(seq 0 6); do
    d=$(date -d "$DATE - $i days" +%Y-%m-%d 2>/dev/null || date -v-${i}d -j -f "%Y-%m-%d" "$DATE" +%Y-%m-%d 2>/dev/null)
    if [ -n "$d" ]; then
      grep "^- $d" "$INDEX" 2>/dev/null | while read -r line; do
        echo "  $line"
      done
    fi
  done
fi

# 6. Check audio files (if audio dir exists)
if [ -d "$DIR/audio" ]; then
  echo ""
  echo "🔊 Audio files:"
  for mp3 in "$DIR/audio"/*.mp3; do
    if [ -f "$mp3" ]; then
      size=$(stat -c%s "$mp3" 2>/dev/null || stat -f%z "$mp3" 2>/dev/null)
      size_mb=$(echo "scale=1; $size / 1048576" | bc)
      name=$(basename "$mp3")
      if [ "$size" -lt 2000000 ]; then
        echo "⚠️ WARN: $name only ${size_mb}MB (expected >2MB for deep content)"
        ERRORS=$((ERRORS + 1))
      else
        echo "✅ $name: ${size_mb}MB"
      fi
    fi
  done
else
  echo "ℹ️ No audio directory yet (podcast cron hasn't run)"
fi

echo ""
echo "========================================="
if [ "$ERRORS" -eq 0 ]; then
  echo "✅ All checks passed!"
  exit 0
else
  echo "❌ $ERRORS issue(s) found"
  exit 1
fi
