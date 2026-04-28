---
name: baoyu-comic
description: Create a concise educational comic, starting with a Codex-friendly four-panel single-page workflow that can generate prompts, render the page, and merge the result into a PDF.
---

# baoyu-comic

Use this skill when the user wants a knowledge comic, educational comic, short business allegory, or four-panel explainer based on an article, note, or idea.

This Codex migration currently focuses on the fastest reliably testable path:

- `four-panel` preset
- single-page comic
- one generated PNG page
- one merged PDF

## Inputs

- A source markdown/article file, or pasted source content
- Optional focus, audience, tone, or accent color

## Defaults

- Preset: `four-panel`
- Art style: `minimalist`
- Tone: `neutral`
- Layout: `four-panel`
- Aspect ratio: `4:3`
- Language: follow the source content or user language

## Workflow

1. Read the source and extract one teachable idea that can fit a strict 起承转合 four-panel arc.
2. Write a short `storyboard.md` with exactly 4 panels:
   - Panel 1: setup
   - Panel 2: development
   - Panel 3: turn
   - Panel 4: conclusion
3. Write a single image prompt for a strict 2x2 comic page.
4. Use `baoyu-imagine` to render the comic page.
5. Merge the page into a PDF with `scripts/merge-to-pdf.ts`.

## Output Structure

Suggested output directory:

`tmp/comic-codex/`

Typical contents:

- `storyboard.md`
- `prompts/01-page-<slug>.md`
- `01-page-<slug>.png`
- `<slug>.pdf`

## Rules

- Keep the page to exactly 4 panels in a strict 2x2 grid.
- Prefer one clear concept over coverage.
- Keep text sparse inside the panels.
- Make panel 3 the strongest visual turn.
- Default to simplified characters and minimal props.
- Save the prompt file before rendering the image.

## References

- Preset rules: `references/presets/four-panel.md`
- Layout rules: `references/layouts/four-panel.md`
- Prompt baseline: `references/base-prompt.md`
- Storyboard format: `references/storyboard-template.md`
