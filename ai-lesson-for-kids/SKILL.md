---
name: ai-lesson-for-kids
description: >
  Run an interactive AI lesson for kids age 7-10 in a classroom setting. The teacher
  collaborates live with an AI agent via a messaging app (e.g. Telegram): updating a
  kid-friendly website in real-time, generating AI images from kids' handwritten prompts
  using Gemini, and embedding a Teachable Machine webcam classifier.
---

# AI Lesson for Kids (Age 7-10)

Interactive ~45-minute AI lesson where kids learn what AI is, train their own image classifier,
and generate AI art — all appearing live on a class website.

## Prerequisites

- **API Keys** (set as environment variables):
  - `NETLIFY_AUTH_TOKEN` — for deploying the website
  - `GEMINI_API_KEY` — for AI image generation
- **Tools:**
  - [Netlify CLI](https://docs.netlify.com/cli/get-started/) (`npm install -g netlify-cli`)
  - `curl`, `python3`, `bash`
- **Hardware:**
  - Computer with webcam + projector for Teachable Machine demo
- **Printed materials:**
  - [CS Unplugged "Intelligent Paper"](https://www.cs4fn.org/teachers/activities/intelligentpaper/intelligentpaper.pdf) tic-tac-toe sheet
  - QR code for the site URL (so kids can show parents at home)

## Quick Setup

### 1. Create a deploy directory and customize the template

```bash
mkdir -p /tmp/ai-lesson-site

# Copy the HTML template
cp assets/template.html /tmp/ai-lesson-site/index.html

# Edit the <title> and <h1> to match your class name
# Replace "NAZWA KLASY" with your class name
```

### 2. Deploy to Netlify

```bash
cd /tmp/ai-lesson-site
npx netlify deploy --dir=. --prod
# Note the site URL and site ID for later deploys
```

### 3. Prepare "What to Watch Out For" images

Generate 3 images based on metaphors kids already know:

```bash
./scripts/generate_image.sh "Pinocchio with a long nose, lying, cartoon style" /tmp/ai-lesson-site/uwaga1.jpg
./scripts/generate_image.sh "the Mirror of Erised from Harry Potter showing someone what they want to see" /tmp/ai-lesson-site/uwaga2.jpg
./scripts/generate_image.sh "a boy in a wheelchair from The Secret Garden, his legs weak from not using them" /tmp/ai-lesson-site/uwaga3.jpg
```

These represent: AI hallucination (Pinocchio), AI sycophancy (Mirror of Erised), and cognitive atrophy from over-reliance on AI (The Secret Garden).

### 4. Redeploy with images and print QR code

```bash
cd /tmp/ai-lesson-site
npx netlify deploy --site YOUR_SITE_ID --dir=. --prod
```

Generate a QR code for the site URL and print it — kids take it home with the tic-tac-toe handout.

## During the Lesson

The teacher controls the lesson from their phone. If using an AI agent (e.g. OpenClaw),
the agent responds to voice notes/messages and updates the website automatically. Without an agent,
you can edit the HTML manually and redeploy — it takes ~10 seconds.

### Update a section

Edit the corresponding `<div class="section">` in `index.html` with the kids' input, then redeploy:

```bash
cd /tmp/ai-lesson-site
npx netlify deploy --site YOUR_SITE_ID --dir=. --prod
```

Redeploy takes ~5 seconds. Kids refresh to see changes.

### Generate image from a kid's prompt

1. Read (or photograph and transcribe) a kid's handwritten prompt
2. Generate the image:

```bash
./scripts/generate_image.sh "KIDS_PROMPT" /tmp/ai-lesson-site/galleryN.png
```

3. Add an `<img>` tag to the gallery section in `index.html` with the kid's name and prompt
4. Redeploy

### Embed Teachable Machine model

1. During class, train a model at https://teachablemachine.withgoogle.com/train/image
2. Export → Upload → copy the model URL
3. Uncomment the Teachable Machine `<div>` and `<script>` sections in `index.html`
4. Replace `YOUR_MODEL_ID` with the actual model URL
5. Redeploy

## Lesson Plan

See [references/lesson-plan.md](references/lesson-plan.md) for the full 6-section lesson plan
with timing (~45 min), tips, and preparation checklist.

## Template

The HTML template is at [assets/template.html](assets/template.html). It includes:
- 6 sections with Polish placeholder text (easily translatable)
- Teachable Machine integration (commented out, ready to activate)
- AI image gallery
- "Na co uważać" (What to Watch Out For) section with 3 image slots
- Responsive, kid-friendly purple gradient design

## Image Generation Script

[scripts/generate_image.sh](scripts/generate_image.sh) generates images via the Gemini API.
Automatically appends "kid-friendly, colorful, cartoon style" to all prompts.

Usage: `./scripts/generate_image.sh "prompt text" output_filename.png`

Requires: `GEMINI_API_KEY` environment variable.

## Tips

- Kids love seeing their words appear on a "real website" — the live updates are engaging
- 30-50 webcam samples per Teachable Machine class is enough
- Let kids write prompts on paper → photograph → transcribe (more fun than typing)
- Rock-Paper-Scissors works great as a Teachable Machine demo (everyone has hands!)
- The "Intelligent Paper" tic-tac-toe hook from [CS Unplugged](https://classic.csunplugged.org/artificial-intelligence/) grabs attention immediately
- Budget at least 15 minutes for the gallery — it's the highlight
- Have a kid be your assistant and follow the paper algorithm (makes it more fun)

## Using with an AI Agent (Optional)

This skill is designed to work with [OpenClaw](https://github.com/openclaw/openclaw) or any
AI agent that can edit files, run shell commands, and deploy websites. The agent acts as
invisible infrastructure — the kids never see it, they just see the website updating.

To use with OpenClaw:
1. Copy this skill folder into your OpenClaw skills directory
2. Set `NETLIFY_AUTH_TOKEN` and `GEMINI_API_KEY` in your `.env`
3. During the lesson, send voice notes via Telegram — the agent handles edits + deploys

But the lesson works perfectly fine without any agent — just edit and deploy manually.
