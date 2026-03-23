#!/bin/bash
# Dream Podcast Generator
# Converts dream narratives to audio using Gemini TTS, then concatenates into a single episode.
#
# Usage: bash scripts/dream_podcast.sh [YYYY-MM-DD] [voice]
# Defaults to today's date and voice "Orus" (firm, good for narration)
#
# Environment variables:
#   GEMINI_API_KEY  — Required. Your Gemini API key.
#   WORKSPACE       — Optional. Workspace root (default: parent of script dir)
#   FFMPEG_PATH     — Optional. Path to ffmpeg binary (default: ffmpeg)
#   DREAMS_VOICE    — Optional. Default TTS voice (default: Orus)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE="${WORKSPACE:-$(dirname "$SCRIPT_DIR")}"
FFMPEG="${FFMPEG_PATH:-ffmpeg}"

# Load .env if present
if [ -f "$WORKSPACE/.env" ]; then
  set -a
  source "$WORKSPACE/.env"
  set +a
fi

# Validate requirements
if [ -z "${GEMINI_API_KEY:-}" ]; then
  echo "ERROR: GEMINI_API_KEY not set. Export it or add to $WORKSPACE/.env"
  exit 1
fi

command -v "$FFMPEG" >/dev/null 2>&1 || { echo "ERROR: ffmpeg not found. Install it or set FFMPEG_PATH."; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "ERROR: jq not found. Install it (apt install jq / brew install jq)."; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "ERROR: curl not found."; exit 1; }

DATE="${1:-$(date +%Y-%m-%d)}"
VOICE="${2:-${DREAMS_VOICE:-Orus}}"
DREAMS_DIR="$WORKSPACE/brain/Dreams/$DATE"
OUTPUT_DIR="/tmp/dream_podcast_${DATE}"

if [ ! -d "$DREAMS_DIR" ]; then
  echo "ERROR: No dreams found at $DREAMS_DIR"
  echo "Ensure the dream writer has run for $DATE."
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "🎙️ Dream Podcast Generator"
echo "Date: $DATE | Voice: $VOICE"
echo "Dreams: $DREAMS_DIR"
echo ""

# Associative array for human-readable labels
declare -A LABELS=(
  ["motivation-family-love"]="Family & Love"
  ["motivation-learning-growth"]="Learning & Growth"
  ["motivation-investments"]="Investments"
  ["motivation-ai-research"]="AI Research"
)

# Collect PCM files for concatenation
PCM_FILES=()
SEGMENT_COUNT=0

for md_file in "$DREAMS_DIR"/motivation-*.md; do
  [ -f "$md_file" ] || continue
  
  basename_noext=$(basename "$md_file" .md)
  label="${LABELS[$basename_noext]:-$basename_noext}"
  
  echo "📝 $label"

  # Look for pre-written narrative (preferred — written by the AI agent during dream phase)
  narrative=""
  alt_name="${basename_noext#motivation-}"
  
  for candidate in \
    "$DREAMS_DIR/${basename_noext}_narrative.txt" \
    "$DREAMS_DIR/${alt_name}_narrative.txt"; do
    if [ -f "$candidate" ]; then
      narrative=$(cat "$candidate")
      echo "  📄 Using pre-written narrative from $(basename "$candidate")"
      break
    fi
  done

  # Fallback: generate narrative from dream markdown using Gemini text model
  if [ -z "$narrative" ]; then
    echo "  📄 No pre-written narrative found, generating with Gemini Flash..."
    dream_content=$(cat "$md_file")

    narrative=$(curl -s --max-time 60 \
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent" \
      -H "x-goog-api-key: $GEMINI_API_KEY" \
      -H "Content-Type: application/json" \
      -X POST \
      -d "$(jq -n --arg content "$dream_content" '{
        contents: [{parts: [{text: ("Convert this into a smooth, engaging podcast-style narrative monologue (600-900 words). Write as if a thoughtful narrator shares late-night insights with a smart friend.\n\nRules:\n- No bullet points, headers, or markdown formatting\n- Conversational but intelligent tone\n- 600-900 words — be thorough but selective\n- Start with a hook, build through the discovery, end with actionable takeaway\n- Do NOT say welcome to the podcast — just dive in\n- MUST end with a complete sentence\n\nContent:\n" + $content)}]}],
        generationConfig: {temperature: 0.7, maxOutputTokens: 2000}
      }')" | jq -r '.candidates[0].content.parts[0].text // "ERROR"')

    if [ "$narrative" = "ERROR" ] || [ -z "$narrative" ]; then
      echo "  ❌ Failed to generate narrative for $label"
      continue
    fi
  fi

  word_count=$(echo "$narrative" | wc -w | tr -d ' ')
  echo "  ✅ Narrative: $word_count words"

  # Validate minimum length
  if [ "$word_count" -lt 50 ]; then
    echo "  ❌ Narrative too short ($word_count words), skipping"
    continue
  fi

  # Generate audio via Gemini TTS
  echo "  🔊 Generating audio (Gemini TTS, voice: $VOICE)..."

  tts_response=$(curl -s --max-time 120 \
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-tts:generateContent" \
    -H "x-goog-api-key: $GEMINI_API_KEY" \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$(jq -n --arg text "$narrative" --arg voice "$VOICE" '{
      contents: [{parts: [{text: ("Read this in a warm, thoughtful, late-night podcast style. Natural pacing with slight pauses between ideas:\n\n" + $text)}]}],
      generationConfig: {
        responseModalities: ["AUDIO"],
        speechConfig: {
          voiceConfig: {
            prebuiltVoiceConfig: {
              voiceName: $voice
            }
          }
        }
      }
    }')")

  # Extract base64 audio data
  audio_data=$(echo "$tts_response" | jq -r '.candidates[0].content.parts[0].inlineData.data // empty')

  if [ -z "$audio_data" ]; then
    err=$(echo "$tts_response" | jq -r '.error.message // "unknown error"')
    echo "  ❌ TTS failed: $err"
    continue
  fi

  # Decode and convert to MP3
  raw_file="$OUTPUT_DIR/${basename_noext}.raw"
  mp3_file="$OUTPUT_DIR/${basename_noext}.mp3"
  
  echo "$audio_data" | base64 -d > "$raw_file"

  # Gemini returns raw PCM L16 at 24000Hz mono
  "$FFMPEG" -y -f s16le -ar 24000 -ac 1 -i "$raw_file" \
    -codec:a libmp3lame -qscale:a 2 "$mp3_file" 2>/dev/null

  if [ -f "$mp3_file" ]; then
    size=$(du -h "$mp3_file" | cut -f1)
    echo "  ✅ Audio: $mp3_file ($size)"
    rm -f "$raw_file"
    PCM_FILES+=("$mp3_file")
    SEGMENT_COUNT=$((SEGMENT_COUNT + 1))
  else
    echo "  ❌ MP3 conversion failed"
    rm -f "$raw_file"
  fi
  echo ""
done

if [ "$SEGMENT_COUNT" -eq 0 ]; then
  echo "❌ No audio segments generated. Check your dreams and API key."
  exit 1
fi

# Concatenate all segments with silence gaps
echo "🔗 Combining $SEGMENT_COUNT segments into single episode..."

# Generate 4 seconds of silence
silence_file="$OUTPUT_DIR/_silence.mp3"
"$FFMPEG" -y -f lavfi -i anullsrc=r=24000:cl=mono -t 4 \
  -codec:a libmp3lame -qscale:a 2 "$silence_file" 2>/dev/null

# Build ffmpeg concat list
concat_list="$OUTPUT_DIR/_concat.txt"
> "$concat_list"
for i in "${!PCM_FILES[@]}"; do
  echo "file '${PCM_FILES[$i]}'" >> "$concat_list"
  if [ "$i" -lt $((${#PCM_FILES[@]} - 1)) ]; then
    echo "file '$silence_file'" >> "$concat_list"
  fi
done

# Concatenate
episode_file="$OUTPUT_DIR/dreams-${DATE}.mp3"
"$FFMPEG" -y -f concat -safe 0 -i "$concat_list" \
  -codec:a libmp3lame -qscale:a 2 "$episode_file" 2>/dev/null

if [ -f "$episode_file" ]; then
  size=$(du -h "$episode_file" | cut -f1)
  echo ""
  echo "🎧 Episode ready: $episode_file ($size)"
  # Cleanup temp files
  rm -f "$silence_file" "$concat_list"
else
  echo "❌ Episode concatenation failed"
  exit 1
fi
