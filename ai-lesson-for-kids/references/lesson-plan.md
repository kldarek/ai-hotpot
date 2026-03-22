# AI Lesson Plan for Kids (Age 7-10)

Total time: ~45 minutes
Language: Polish (easily adaptable to any language)
Website: Updated live during class via manual edits or AI agent + Netlify

## Preparation Checklist

- [ ] Deploy blank template to Netlify (see SKILL.md setup)
- [ ] Generate 3 "Na co uważać" images and deploy them
- [ ] Print QR code with site URL for kids
- [ ] Test webcam works with Teachable Machine
- [ ] Prepare projector/screen showing the website
- [ ] Have paper and markers ready for kids' prompts (Section 6)
- [ ] Prepare a tic-tac-toe paper algorithm for the "Is paper intelligent?" demo
- [ ] Test the full pipeline: edit → deploy → page refresh

## Lesson Structure

### Section 1: Czym jest Sztuczna Inteligencja? (~7 min)

**Goal:** Define AI in kid-friendly terms.

**Hook:** "Czy kartka papieru może być inteligentna?" (Can a piece of paper be intelligent?)
- Show the tic-tac-toe paper algorithm — a sheet of paper that plays tic-tac-toe using simple rules
- Kids play against it. It wins (or draws). The paper is "intelligent"!
- Key insight: AI = a set of simple rules that together create something smart

**Discussion points:**
- AI is a computer program that can learn, like you learn at school
- AI learns from examples — the more examples it sees, the better it gets
- Ask kids: "Where have you seen AI?" (Siri, YouTube recommendations, etc.)

**Website update:** Summarize what the kids said → update Section 1 → redeploy.

**Tips:**
- Let kids actually play against the paper algorithm — hands-on is key
- Don't rush the "aha moment" when they realize paper can be smart

---

### Section 2: Jak trenuje się AI? — Teachable Machine (~10 min)

**Goal:** Kids train their own AI model and see it work live.

**Activity:**
1. Open https://teachablemachine.withgoogle.com/train/image on the projector
2. Create 3 classes (e.g., Rock ✊, Paper ✋, Scissors ✌️)
3. Let kids take turns showing gestures to the webcam (~30-50 samples per class)
4. Click "Train Model" (~30 seconds)
5. Test it live — kids show gestures and see predictions
6. Export → Upload → copy model URL

**Website update:** Insert the model URL into the Teachable Machine section of the HTML → redeploy. Kids can now open the site on their tablets and use the classifier!

**Tips:**
- Rock-Paper-Scissors works perfectly — every kid has hands, no props needed
- Let EVERY kid participate in training (take turns at the webcam)
- The moment when the model first correctly recognizes a gesture → huge excitement
- If time is tight, pre-train 2 classes and let kids add the 3rd

---

### Section 3: Jak działa AI? (~5 min)

**Goal:** Demystify neural networks at a very basic level.

**Explain (simplified):**
- 📸 A computer sees images as **numbers** — each pixel is just a number
- ✖️ A neuron takes those numbers and does **multiplication** and **addition** — basic math!
- 🎯 The result is a **prediction** — "that's paper!" or "that's rock!"
- One neuron isn't enough — but thousands of neurons together form a **neural network**

**Connect to Teachable Machine:** "That's exactly how our Rock-Paper-Scissors model works!"

**Website update:** Update Section 3 with the explanation → redeploy.

**Tips:**
- Don't go deeper than multiply + add → prediction
- Use the Teachable Machine model they just trained as the concrete example
- "Your brain has 86 billion neurons. Our model has... a lot fewer!"

---

### Section 4: Po co nam AI? (~5 min)

**Goal:** Show real-world AI applications kids can relate to.

**Examples to discuss:**
- 🏥 Doctors use AI to find diseases in X-rays
- 🚗 Self-driving cars
- 🎵 Spotify/YouTube recommendations
- 📱 Siri, Google Assistant — understanding speech
- 🎨 AI can draw pictures from descriptions (they'll do this next!)
- 📝 Helps with learning and translation

**Website update:** Update Section 4 with the kids' answers → redeploy.

**Tips:**
- Ask kids what THEY would use AI for — their answers are always creative
- Build anticipation for the gallery section: "We're about to make AI draw YOUR ideas!"

---

### Section 5: Na co uważać? (~5 min)

**Goal:** Teach critical thinking about AI — age-appropriate risks.

**Activity:** Show the 3 pre-generated images (already on the website) and discuss:
1. **Deepfakes / fake images** — "AI can make pictures that look real but aren't"
2. **Bias / unfairness** — "AI can make mistakes if it learned from bad examples"
3. **Privacy** — "Be careful what you share with AI"

**Homework tie-in:** "Show these pictures to your parents — can THEY figure out what each one means?"

**Tips:**
- Keep it light but honest — kids handle these concepts well when presented simply
- The parent homework angle makes it sticky (kids explain AI risks to parents!)

---

### Section 6: Promptowanie — Galeria AI (~13+ min)

**Goal:** Kids create AI art from their own prompts.

**Activity:**
1. Hand out paper and markers
2. Each kid writes (or draws) what they want AI to create
3. Read or photograph each prompt, then generate the image:
   ```bash
   ./scripts/generate_image.sh "kid's prompt" /tmp/ai-lesson-site/galleryN.png
   ```
4. Add the image to the gallery section in `index.html`
5. Redeploy — kids watch their creation appear on the website in real-time!

**Tips:**
- This is THE highlight — budget plenty of time (15-20 min if possible)
- Process prompts in batches if the class is large
- Some kids will want multiple images — set expectations (1 per kid first, extras if time allows)
- Read each prompt aloud before generating — builds anticipation
- The handwriting transcription step amazes kids ("AI can read my writing?!")
- Each generation takes ~10-15 seconds — fill the wait with discussion

## Timing Summary

- Section 1 → What is AI? (+ paper algorithm) → ~7 min
- Section 2 → Teachable Machine training → ~10 min
- Section 3 → How does AI work? (neurons) → ~5 min
- Section 4 → Why do we need AI? → ~5 min
- Section 5 → What to watch out for → ~5 min
- Section 6 → AI Gallery (prompts) → ~13 min
- **Total → ~45 min**

## After the Lesson

- The website stays live — kids can show parents at home
- Parents scan the QR code to see the gallery and try the Teachable Machine model
- Consider doing a final "clean" deploy with polished text after class
