# Cron Setup Guide — Dreams Audio

The Dreams system uses two scheduled jobs:

1. **Dream Writer** (late evening) — AI agent explores topics and writes dreams + narratives
2. **Podcast Generator** (early morning) — converts narratives to audio and delivers the episode

## OpenClaw Cron Setup

### Job 1: Dream Writer (recommended: 23:00)

Create an OpenClaw cron job that runs your AI agent with the following prompt structure:

**Schedule:** `0 23 * * *` (every night at 11 PM)

**Example Prompt:**

```
You are running the nightly DREAMS pipeline. Today is {date}.

## Your Task
Write 4 deep explorations ("dreams") and their matching podcast narratives.

## Categories
1. **Family & Relationships** (slug: family-love)
2. **Learning & Growth** (slug: learning-growth)  
3. **Investments & Finance** (slug: investments)
4. **AI & Professional Interests** (slug: ai-research)

## Process for Each Category

1. **Scan for inspiration:**
   - Read recent files in $WORKSPACE/brain/notes/ for topics, interests, bookmarks
   - Check $WORKSPACE/brain/Dreams/DREAM_INDEX.md — do NOT repeat topics from the last 7 days
   - Do 1-2 web searches to find fresh angles, recent papers, or current events

2. **Write the dream exploration** (save as motivation-{slug}.md):
   - 1000-3000 words, deep and insightful
   - Use markdown with frontmatter (date, category, title, word_count)
   - Include: hook, mechanism/analysis, deeper implications, action items, connections
   - Be specific — cite papers, use numbers, name frameworks
   - This should read like a research memo from a brilliant friend, not a generic blog post

3. **Write the podcast narrative** (save as {slug}_narrative.txt):
   - 600-900 words, plain text only (no markdown — this goes directly to TTS)
   - Conversational but intelligent tone — like sharing insights with a smart friend at 2 AM
   - Start with a hook, build through the discovery, end with actionable takeaway
   - Must end with a complete sentence and proper conclusion
   - No "welcome to the podcast" or similar — just dive in

4. **Update the dream index** — append to DREAM_INDEX.md:
   ```
   - {date} | {slug} | {title}
   ```

## Output Directory
Save all files to: $WORKSPACE/brain/Dreams/{date}/

## Quality Standards
- Each dream must have a UNIQUE angle — check the index for what's been covered
- Narratives must be TTS-ready: no abbreviations, spell out numbers, no markdown
- If a topic was covered in the last 7 days, find a completely different angle or pick a new topic
- Depth over breadth — one deep insight beats five shallow observations

## After Writing All 4
- Git add, commit, and push the new dreams
- Verify: all 4 .md files exist, all 4 _narrative.txt files exist, index updated
```

### Job 2: Podcast Generator (recommended: 05:00)

**Schedule:** `0 5 * * *` (every morning at 5 AM)

**Example Prompt:**

```
Generate today's dream podcast episode.

Run: bash $WORKSPACE/scripts/dream_podcast.sh {date}

If successful, the episode will be at /tmp/dream_podcast_{date}/dreams-{date}.mp3

Send the MP3 to the user via their preferred delivery method (Telegram, email, etc.).

If the script fails:
1. Run: bash $WORKSPACE/scripts/validate_dreams.sh {date}
2. Report any issues found
3. If narratives are missing, check if the dream writer ran successfully
```

## Manual/System Cron Setup

If not using OpenClaw, you can use standard crontab:

```bash
# Edit crontab
crontab -e

# Add these lines (adjust paths):
# Dream writer — requires an AI agent (OpenClaw, or call an LLM API)
0 23 * * * cd $HOME/workspace && bash scripts/run_dream_writer.sh >> logs/dreams.log 2>&1

# Podcast generator — pure shell script, no AI needed
0 5 * * * cd $HOME/workspace && bash scripts/dream_podcast.sh >> logs/podcast.log 2>&1
```

## Delivery Options

### Telegram Bot

Send the episode via Telegram bot API:

```bash
EPISODE="/tmp/dream_podcast_${DATE}/dreams-${DATE}.mp3"
TELEGRAM_BOT_TOKEN="your-bot-token"
TELEGRAM_CHAT_ID="your-chat-id"

curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendAudio" \
  -F "chat_id=${TELEGRAM_CHAT_ID}" \
  -F "audio=@${EPISODE}" \
  -F "title=Dreams ${DATE}" \
  -F "caption=🌙 Your nightly dreams podcast — ${DATE}"
```

### Email

```bash
# Using msmtp or sendmail
echo "Your dreams podcast for ${DATE}" | \
  mail -s "🌙 Dreams ${DATE}" -A "$EPISODE" your@email.com
```

### File Sync

Just point the output to a synced folder (Dropbox, Syncthing, etc.):

```bash
cp "$EPISODE" "$HOME/Dropbox/Podcasts/"
```

## Timing Considerations

- **Dream Writer** should run late enough that your day's notes are captured
- **Podcast Generator** should run early enough that the episode is ready when you wake up
- Leave at least 4-6 hours between them (dreams take ~10 min to write, but you want a buffer)
- The podcast script takes ~5-10 minutes depending on TTS provider latency

## Monitoring

Use `validate_dreams.sh` to check pipeline health:

```bash
# Check today
bash scripts/validate_dreams.sh

# Check specific date
bash scripts/validate_dreams.sh 2026-03-22

# Quick daily health check in cron (after podcast generator)
15 5 * * * bash $HOME/workspace/scripts/validate_dreams.sh || echo "Dreams validation failed" | mail -s "⚠️ Dreams Alert" your@email.com
```
