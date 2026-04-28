---
name: baoyu-image-cards
description: Generate social-media image card series with a Codex-friendly workflow. Use when the user wants a Xiaohongshu-style card series, image-card explainer, or multi-image social summary from markdown, article content, or pasted notes.
---

# Image Cards

This is the Codex pilot version of the original Baoyu image-cards skill.

## What Changed For Codex

- Removed Claude-only interactive branching such as `AskUserQuestion`
- Removed the mandatory first-run preferences blocker
- Reduced the pilot scope to a small but real multi-card series
- Reused `baoyu-imagine` for the actual rendering of each card

## Files

- Main skill file: `skills/baoyu-image-cards/SKILL.md`
- Analysis guide: `skills/baoyu-image-cards/references/workflows/analysis-framework.md`
- Outline template: `skills/baoyu-image-cards/references/workflows/outline-template.md`
- Prompt assembly guide: `skills/baoyu-image-cards/references/workflows/prompt-assembly.md`
- Reference style: `skills/baoyu-image-cards/references/presets/notion.md`

## Dependencies

This skill depends on:
- `baoyu-imagine` for image generation
- a provider credential for live rendering

## Preferences

Preferences are optional. Check these locations in order:

```bash
test -f .baoyu-skills/baoyu-image-cards/EXTEND.md && echo project
test -f "${XDG_CONFIG_HOME:-$HOME/.config}/baoyu-image-cards/EXTEND.md" && echo xdg
test -f "$HOME/.baoyu-skills/baoyu-image-cards/EXTEND.md" && echo user
```

If an `EXTEND.md` file exists, read and apply it.

If none exists:
- do not block the current run
- auto-select style and layout from the content
- use a short default series instead of a long interactive planning flow
- save defaults only when the user explicitly asks for persistence

## Recommended Workflow

1. Read the source article or notes.
2. Split it into a small narrative series: cover, core value, ending.
3. Choose one style and a small set of layouts for the series.
4. Build one prompt per card.
5. Generate each card through `baoyu-imagine`.
6. Save prompts and output files together.

## Default Bias

For technical or knowledge content:
- style: `notion`
- cover layout: `sparse`
- content layout: `dense`
- ending layout: `balanced`
- aspect ratio: `3:4`

## Validation

An image-cards run is only considered validated when:
- multiple prompt files are saved
- multiple images are generated
- the series has a visible narrative progression
- the cards look like a coherent set rather than unrelated single images
