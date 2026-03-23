# 🌙 Dreams Audio — AI-Generated Personalized Nightly Podcast

**An autonomous system that explores your interests every night and delivers a personalized podcast episode by morning.**

> *"What if an AI spent every night thinking deeply about the things you care about — and turned those thoughts into a podcast you could listen to over breakfast?"*

Read the full story: [Artificial Dreaming Machine](https://skok.ai/post/2026-02-21-artificial-dreaming-machine)

---

## What It Does

Every night, an AI agent:

1. **Explores 4 themes** based on your notes, interests, and current events
2. **Writes deep explorations** (1000–3000 words each) called "dreams" — think research memos with genuine insight
3. **Converts each dream into a podcast narrative** (600–900 words, TTS-optimized plain text)
4. **Generates audio** for each narrative using text-to-speech (Gemini TTS, ElevenLabs, or local models)
5. **Concatenates** the 4 segments into a single episode with natural pauses
6. **Delivers** the episode (e.g., via Telegram, email, or file sync)

You wake up to a ~15–25 minute personalized podcast covering your world.

## Default Categories (Configurable)

| # | Category | What It Explores |
|---|----------|-----------------|
| 1 | **Family & Relationships** | Personal life, parenting insights, relationship dynamics |
| 2 | **Learning & Growth** | Health, fitness, psychology, skill-building |
| 3 | **Investments & Finance** | Market analysis, thesis development, portfolio ideas |
| 4 | **AI & Professional** | Research papers, industry trends, career-relevant tech |

You can customize these to any 4 (or more) themes that matter to you.

## Output Structure

```
brain/Dreams/
├── DREAM_INDEX.md                          # Master index of all dreams (dedup tracking)
├── 2026-03-22/
│   ├── motivation-family-love.md           # Dream exploration (markdown)
│   ├── motivation-learning-growth.md
│   ├── motivation-investments.md
│   ├── motivation-ai-research.md
│   ├── family-love_narrative.txt           # TTS-ready narrative (plain text)
│   ├── learning-growth_narrative.txt
│   ├── investments_narrative.txt
│   ├── ai-research_narrative.txt
│   └── audio/
│       ├── motivation-family-love.mp3      # Individual segments
│       ├── motivation-learning-growth.mp3
│       ├── motivation-investments.mp3
│       └── motivation-ai-research.mp3
└── 2026-03-23/
    └── ...
```

The final combined episode lands in `/tmp/dream_podcast_YYYY-MM-DD/dreams-YYYY-MM-DD.mp3`.

## TTS Options

| Provider | Cost | Quality | Setup |
|----------|------|---------|-------|
| **Gemini TTS** | Free tier available | Good, multiple voices | API key only |
| **ElevenLabs** | Paid (~$5–22/mo) | Excellent, natural | API key + voice ID |
| **Local (Qwen3-TTS)** | Free (GPU required) | Good | Requires GPU + model setup |

## Quick Start

1. Set up your workspace with a `brain/Dreams/` directory
2. Get a [Gemini API key](https://aistudio.google.com/apikey) (free)
3. Install `ffmpeg` and `jq`
4. Configure the cron jobs (see [SKILL.md](./SKILL.md))
5. Wake up to your podcast

## Requirements

- **OpenClaw** (recommended) or any AI agent framework for the dream writing phase
- **Gemini API key** (free tier works for TTS)
- **ffmpeg** — audio processing
- **jq** — JSON handling in shell scripts
- **bash** — the podcast generator script

## License

MIT — see [LICENSE](../LICENSE)
