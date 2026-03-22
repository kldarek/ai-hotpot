# AI Lesson for Kids (Age 7-10)

A ready-to-use recipe for teaching AI to elementary school kids in a ~45-minute interactive lesson.

Kids will:
- Discover what AI is (using a paper tic-tac-toe algorithm)
- Train their own image classifier with [Teachable Machine](https://teachablemachine.withgoogle.com/)
- Generate AI art from their handwritten prompts
- Learn what to watch out for with AI (using Pinocchio, Harry Potter, and The Secret Garden)

Everything appears live on a class website projected on the wall. Kids see their words and images appear in real-time.

## What's Inside

```
ai-lesson-for-kids/
├── SKILL.md                    # Full setup & usage instructions
├── README.md                   # This file
├── assets/
│   └── template.html           # Kid-friendly website template (single HTML file)
├── scripts/
│   └── generate_image.sh       # Gemini API image generation script
└── references/
    └── lesson-plan.md          # Detailed 6-section lesson plan with timing & tips
```

## Quick Start

1. Set your API keys: `NETLIFY_AUTH_TOKEN` and `GEMINI_API_KEY`
2. Copy `assets/template.html` → customize the class name → deploy to Netlify
3. Print the [CS Unplugged "Intelligent Paper"](https://www.cs4fn.org/teachers/activities/intelligentpaper/intelligentpaper.pdf) tic-tac-toe sheet
4. Follow the [lesson plan](references/lesson-plan.md)
5. During class: edit the HTML with kids' input, generate images, redeploy

Full instructions in [SKILL.md](SKILL.md).

## Requirements

- Netlify account (free tier works)
- Gemini API key (for image generation)
- Laptop with webcam + projector
- Paper and pencils for kids' prompts
- ~45 minutes of class time

## Works With or Without an AI Agent

This skill is designed for [OpenClaw](https://github.com/openclaw/openclaw) but works perfectly
fine without any AI platform. The instructions are human-readable, the scripts are standalone,
and the HTML template has no dependencies.

With an agent: send voice notes from your phone → agent edits + deploys automatically (~5 sec).
Without an agent: edit HTML manually and run `npx netlify deploy` (~15 sec).

## Blog Post

Read the full story of how this lesson went with a class of 20 eight-year-olds:
- [Teaching AI to 8-Year-Olds](https://skok.ai/post/2026-03-22-teaching-ai-to-8-year-olds) (English)
- [Lekcja AI dla 8-latków](https://skok.ai/post/2026-03-22-teaching-ai-to-8-year-olds-pl) (Polish)

## License

MIT — see [LICENSE](../LICENSE).
