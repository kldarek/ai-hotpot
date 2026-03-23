# Dreams Audio Skill

> Personalized nightly AI podcast — the agent explores your interests while you sleep, generates deep written explorations, converts them to audio, and delivers a podcast episode by morning.

## Overview

This skill has two phases that run as separate scheduled jobs:

1. **Dream Writer** — An AI agent writes 4 deep explorations ("dreams") based on your notes/interests, plus TTS-ready narrative scripts
2. **Podcast Generator** — A shell script converts the narratives to audio via Gemini TTS, concatenates them into a single episode, and delivers it

Read the full story: [Artificial Dreaming Machine](https://skok.ai/post/2026-02-21-artificial-dreaming-machine)

## Prerequisites

- **OpenClaw** — for scheduling the dream writer cron job
- **Gemini API key** — free at [aistudio.google.com/apikey](https://aistudio.google.com/apikey)
- **ffmpeg** — audio concatenation (`apt install ffmpeg` or `brew install ffmpeg`)
- **jq** — JSON processing (`apt install jq` or `brew install jq`)
- **curl** — HTTP requests (usually pre-installed)

## Setup

### 1. Environment Variables

Add to your `.env` file or export in your shell:

```bash
# Required
export GEMINI_API_KEY="your-gemini-api-key"

# Optional — defaults shown
export WORKSPACE="$HOME/clawd"              # Your agent workspace root
export FFMPEG_PATH="ffmpeg"                 # Path to ffmpeg binary
export DREAMS_VOICE="Orus"                  # Gemini TTS voice name
```

**Available Gemini TTS voices:** Orus (firm, narrator), Kore (warm, female), Charon (deep, male), Fenrir (energetic), Aoede (gentle). See [Gemini TTS docs](https://ai.google.dev/gemini-api/docs/text-to-speech).

### 2. Directory Structure

Create the dreams directory in your workspace:

```bash
mkdir -p "$WORKSPACE/brain/Dreams"
touch "$WORKSPACE/brain/Dreams/DREAM_INDEX.md"
```

Initialize the index file:

```markdown
# Dream Index — Topics Already Explored
# Updated automatically. DREAMS cron must check this to avoid repetition.
# Format: date | slug | title
```

### 3. Install the Podcast Script

```bash
cp scripts/dream_podcast.sh "$WORKSPACE/scripts/"
chmod +x "$WORKSPACE/scripts/dream_podcast.sh"
```

### 4. Configure Categories

The default 4 categories are:

1. **family-love** — Family & relationships
2. **learning-growth** — Learning, health & personal growth  
3. **investments** — Finance & investing
4. **ai-research** — AI/ML & professional interests

To customize, update the dream writer cron prompt and the `LABELS` associative array in `dream_podcast.sh`.

### 5. Set Up Cron Jobs

See [references/cron-setup.md](references/cron-setup.md) for detailed cron configuration including example prompts.

**Quick version:**

- **Dream Writer** — runs at ~23:00, writes dreams + narratives via AI agent
- **Podcast Generator** — runs at ~05:00, converts narratives to audio

## How It Works

### Phase 1: Dream Writing (AI Agent)

The AI agent (via OpenClaw cron):

1. Scans your notes directory for recent interests, bookmarks, and topics
2. Checks `DREAM_INDEX.md` to avoid repeating recent topics
3. Does web searches for fresh information on each theme
4. Writes 4 deep explorations (1000–3000 words each) as markdown
5. Writes 4 podcast narratives (600–900 words each) as plain text
6. Updates the dream index
7. Commits and pushes to git

### Phase 2: Audio Generation (Shell Script)

The podcast generator script:

1. Reads the narrative `.txt` files for the target date
2. Sends each narrative to Gemini TTS API
3. Converts the raw PCM audio to MP3
4. Concatenates all segments with 4-second silence gaps
5. Outputs the final episode MP3

### Usage

```bash
# Generate podcast for today's dreams
bash scripts/dream_podcast.sh

# Generate for a specific date
bash scripts/dream_podcast.sh 2026-03-22

# Use a different voice
bash scripts/dream_podcast.sh 2026-03-22 Kore
```

### Validation

```bash
# Check that dreams + narratives + audio are all present and valid
bash scripts/validate_dreams.sh 2026-03-22
```

## Alternative TTS Providers

### ElevenLabs (Higher Quality, Paid)

Replace the Gemini TTS call with ElevenLabs API:

```bash
curl -s "https://api.elevenlabs.io/v1/text-to-speech/$VOICE_ID" \
  -H "xi-api-key: $ELEVENLABS_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"text\": \"$narrative\", \"model_id\": \"eleven_multilingual_v2\"}" \
  --output "$mp3_file"
```

### Local TTS (Free, GPU Required)

For fully offline generation, use models like:
- **Qwen3-TTS** — Good quality, needs GPU with ~8GB VRAM
- **Coqui TTS** — Open source, various models
- **Piper** — Lightweight, CPU-friendly

Local TTS setup is hardware-specific; see the respective model documentation.

## Output

Each run produces:

- Individual MP3 files per dream segment
- Combined episode: `/tmp/dream_podcast_YYYY-MM-DD/dreams-YYYY-MM-DD.mp3`
- Typical episode: 15–25 minutes, 15–25 MB

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "No dreams found" | Dream writer cron hasn't run yet, or wrong date |
| TTS returns empty audio | Check Gemini API key and quota |
| ffmpeg not found | Install ffmpeg or set `$FFMPEG_PATH` |
| Narratives too short | Check dream markdown files have content; validate with `validate_dreams.sh` |
| Audio quality poor | Try different voice, or switch to ElevenLabs |

## File Reference

```
dreams-audio/
├── README.md                    # Overview
├── SKILL.md                     # This file — setup & usage
├── scripts/
│   ├── dream_podcast.sh         # Main podcast generator (Gemini TTS)
│   └── validate_dreams.sh       # Pipeline validation
└── references/
    ├── sample-dream.md          # Example dream exploration
    ├── sample-narrative.txt     # Example TTS narrative
    └── cron-setup.md            # Cron job configuration guide
```
