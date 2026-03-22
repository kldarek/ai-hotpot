# AI Lesson Plan for Kids (Age 7-10)

Total time: ~45 minutes
Language: Polish (easily adaptable to any language)
Website: Updated live during class via manual edits or AI agent + Netlify

## Preparation Checklist

- [ ] Deploy blank template to Netlify (see SKILL.md setup)
- [ ] Generate 3 "Na co uważać" images (Pinocchio, Mirror of Erised, Secret Garden) and deploy them
- [ ] Print [CS Unplugged "Intelligent Paper"](https://www.cs4fn.org/teachers/activities/intelligentpaper/intelligentpaper.pdf) tic-tac-toe sheets
- [ ] Print QR code with site URL (kids take it home)
- [ ] Test webcam works with Teachable Machine
- [ ] Prepare projector/screen showing the website
- [ ] Have paper and pencils ready for kids' prompts (Section 6)
- [ ] Test the full pipeline: edit → deploy → page refresh

## Lesson Structure

### Section 1: Czym jest Sztuczna Inteligencja? (~7 min)

**Goal:** Define AI in kid-friendly terms.

**Hook:** "Czy kartka papieru może być inteligentna?" (Can a piece of paper be intelligent?)
- Pull out the [CS Unplugged "Intelligent Paper"](https://classic.csunplugged.org/artificial-intelligence/) — a tic-tac-toe algorithm printed on paper
- Have a kid (or your own child as assistant) follow the algorithm and play against a volunteer
- The paper never loses — at best the opponent draws
- Key insight: intelligence = the right set of rules. A computer that follows rules can be intelligent. That's AI.

**Website update:** Summarize what the kids said → update Section 1 → redeploy.

**Tips:**
- Let a kid be the "paper's operator" — following the algorithm makes it more fun and engaging
- The draw/win moment is the hook — don't rush it

---

### Section 2: Od reguł do uczenia maszynowego — Teachable Machine (~10 min)

**Goal:** Show why rules aren't enough, then let kids train their own ML model.

**Bridge from Section 1:**
- The paper works because someone wrote clever rules for tic-tac-toe
- But what about recognizing hand gestures? Writing rules for that is basically impossible
- This is where machine learning comes in — instead of writing rules, we show examples

**Activity:**
1. Open https://teachablemachine.withgoogle.com/train/image on the projector
2. Create 3 classes: Rock, Paper, Scissors
3. Let kids take turns showing gestures to the webcam (~30-50 samples per class)
4. Click "Train Model" (~30 seconds)
5. Test it live — kids show gestures and see predictions
6. Export → Upload → copy model URL

**Website update:** Insert the model URL into the Teachable Machine section of the HTML → redeploy. Kids can show their parents at home.

**Key moment:** If the model gets something wrong (e.g. Paper), ask kids why. They often figure out "not enough examples" on their own — that's the ML feedback loop.

**Tips:**
- Rock-Paper-Scissors works perfectly — every kid has hands, no props needed
- Let EVERY kid participate in training (take turns at the webcam)
- If time is tight, pre-train 2 classes and let kids add the 3rd
- Connection to real work: "This is what I do at my job — train models, see what's not working, add more data, retrain"

---

### Section 3: Jak działa AI? (~5 min)

**Goal:** Demystify neural networks at a very basic level.

**Activity:**
- Ask kids: "What is a picture for a computer?" — guide them to pixels
- Use a necklace with colored beads as analogy: each bead is a pixel, each pixel is a number
- A neuron takes those numbers and does **multiplication** and **addition** — basic math!
- One neuron isn't enough — but thousands of neurons together form a **neural network**
- Connect to Teachable Machine: "That's how our Rock-Paper-Scissors model works!"

**Optional:** Ask ChatGPT live: "Is this how you work? Multiplication and addition?" — it confirms, and kids find it fascinating.

**Website update:** Update Section 3 with the explanation → redeploy.

**Tips:**
- Don't go deeper than multiply + add → prediction
- Use the Teachable Machine model they just trained as the concrete example

---

### Section 4: Po co nam AI? (~5 min)

**Goal:** Show real-world AI applications kids can relate to.

**Activity:**
- Ask kids to come up with use cases together
- Share relatable examples (e.g. using ChatGPT for a cookie recipe, AI for work, for education)
- The answer kids gravitate to naturally: **for fun** — drawing, music, games. That's a perfectly valid answer.

**Website update:** Update Section 4 with the kids' answers → redeploy.

**Tips:**
- Let kids share their own experiences with AI first
- Build anticipation for the gallery section: "We're about to make AI draw YOUR ideas!"

---

### Section 5: Na co uważać? (~5 min)

**Goal:** Teach critical thinking about AI using metaphors kids already know.

**Three images (pre-generated, already on the website):**

1. **Pinocchio** — AI can lie. Not on purpose, but it can confidently say things that aren't true. Just like Pinocchio — the words sound right, but they might be made up. (AI hallucination)

2. **The Mirror of Erised (Harry Potter)** — The mirror shows what you want to see, not what's true. AI tends to tell you what you want to hear. "Is my idea great?" → "Yes!" That doesn't mean it is. (Sycophancy)

3. **The Secret Garden** — A boy in a wheelchair, not because his legs are broken, but because he never uses them. When he walks, they get stronger. If you let AI do all your thinking, your brain won't get stronger. (Cognitive atrophy / over-reliance)

**Activity:** Show the images and ask kids what they think each one means. They figure it out themselves.

**Homework:** "Show these pictures to your parents tonight. See if THEY can figure out what each one means." — Making kids the teachers of AI safety to their own parents.

---

### Section 6: Promptowanie — Galeria AI (~13+ min)

**Goal:** Kids create AI art from their own prompts.

**Activity:**
1. Hand out paper and pencils
2. Each kid writes what they want AI to create
3. Read or photograph each prompt, then generate the image:
   ```bash
   ./scripts/generate_image.sh "kid's prompt" /tmp/ai-lesson-site/galleryN.png
   ```
4. Add the image to the gallery section in `index.html`
5. Redeploy — kids watch their creation appear on the website!

**Tips:**
- This is THE highlight — budget plenty of time (15-20 min if possible)
- Process prompts in batches if the class is large
- Some kids will want multiple images — set expectations (1 per kid first, extras if time allows)
- Read each prompt aloud before generating — builds anticipation
- The handwriting transcription step amazes kids ("AI can read my writing?!")
- Each generation takes ~10-15 seconds — fill the wait with discussion

## Timing Summary

- Section 1 → What is AI? (+ intelligent paper) → ~7 min
- Section 2 → From rules to ML (Teachable Machine) → ~10 min
- Section 3 → How does AI work? (neurons) → ~5 min
- Section 4 → Why do we need AI? → ~5 min
- Section 5 → What to watch out for (3 metaphors) → ~5 min
- Section 6 → AI Gallery (prompts) → ~13 min
- **Total → ~45 min**

## The Ending

- Each kid gets a handout: the tic-tac-toe "intelligent paper" + QR code to the website
- Tell them to show parents the website at home
- The website stays live — parents can see the gallery and try the Teachable Machine model
