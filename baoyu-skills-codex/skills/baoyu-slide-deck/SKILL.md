---
name: baoyu-slide-deck
description: Generate slide deck image sets with a Codex-friendly workflow. Use when the user wants a presentation-style visual deck, mini slide sequence, or shareable slide summary from markdown, article content, or pasted notes.
---

# Slide Deck

This is the Codex pilot version of the original Baoyu slide-deck skill.

## What Changed For Codex

- Removed Claude-only review and `AskUserQuestion` branches
- Reduced the pilot scope to a small but real 3-slide deck
- Reused `baoyu-imagine` for slide rendering
- Kept artifact bundling through PPTX/PDF merge scripts

## Files

- Main skill file: `skills/baoyu-slide-deck/SKILL.md`
- Outline template: `skills/baoyu-slide-deck/references/outline-template.md`
- Base prompt: `skills/baoyu-slide-deck/references/base-prompt.md`
- Analysis guide: `skills/baoyu-slide-deck/references/analysis-framework.md`
- Reference style: `skills/baoyu-slide-deck/references/styles/blueprint.md`
- Merge scripts: `skills/baoyu-slide-deck/scripts/merge-to-pptx.ts`, `skills/baoyu-slide-deck/scripts/merge-to-pdf.ts`

## Dependencies

This skill depends on:
- `baoyu-imagine` for slide image generation
- `pptxgenjs` and `pdf-lib` for bundling artifacts
- a provider credential for live image generation

## Recommended Workflow

1. Read the source article or notes.
2. Produce a compact outline with cover, one core content slide, and one closing slide.
3. Build one prompt per slide.
4. Generate slide images through `baoyu-imagine`.
5. Merge generated slides into `.pptx` and `.pdf`.

## Default Bias

For technical/system content:
- style: `blueprint`
- aspect ratio: `16:9`
- slide count: `3` in the pilot path

## Validation

A slide-deck run is only considered validated when:
- `outline.md` is saved
- slide prompt files are saved
- multiple slide images are generated
- both `.pptx` and `.pdf` artifacts are created
