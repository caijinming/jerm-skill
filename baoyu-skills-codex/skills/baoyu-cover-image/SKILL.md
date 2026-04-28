---
name: baoyu-cover-image
description: Generate article cover images with a Codex-friendly workflow. Use when the user wants a blog cover, article header, or social cover image derived from an article, markdown file, or pasted content, especially when visual style and text treatment should be chosen from content rather than specified manually.
---

# Cover Image

This is the Codex pilot version of the original Baoyu cover-image skill.

## What Changed For Codex

- Removed Claude-only `AskUserQuestion` assumptions
- Removed the mandatory first-run preference blocker
- Defaulted to auto-selection plus a quick path when the user does not care about every dimension
- Reused `baoyu-imagine` as the generation backend instead of inventing a separate execution layer

## Files

- Main skill file: `skills/baoyu-cover-image/SKILL.md`
- Auto-selection rules: `skills/baoyu-cover-image/references/auto-selection.md`
- Style presets: `skills/baoyu-cover-image/references/style-presets.md`
- Prompt template: `skills/baoyu-cover-image/references/workflow/prompt-template.md`
- Preference schema: `skills/baoyu-cover-image/references/config/preferences-schema.md`

## Dependencies

This skill depends on:
- `baoyu-imagine` for actual image generation
- a provider credential for live image generation

## Preferences

Preferences are optional. Check these locations in order:

```bash
test -f .baoyu-skills/baoyu-cover-image/EXTEND.md && echo project
test -f "${XDG_CONFIG_HOME:-$HOME/.config}/baoyu-skills/baoyu-cover-image/EXTEND.md" && echo xdg
test -f "$HOME/.baoyu-skills/baoyu-cover-image/EXTEND.md" && echo user
```

If an `EXTEND.md` file exists, read and apply it.

If none exists:
- do not block the task
- use auto-selection defaults for the current run
- ask at most one concise follow-up only if the user cares about a specific style direction
- save defaults only when the user explicitly wants persistence

## Recommended Workflow

1. Read the article or pasted content.
2. Extract title, summary, tone, and keywords.
3. Auto-select type, palette, rendering, text level, mood, and font unless the user already specified them.
4. Build a structured cover prompt file.
5. Generate the image through `baoyu-imagine`.
6. Save the prompt and output image together so the run is reproducible.

## Auto-Selection

Use [references/auto-selection.md](references/auto-selection.md) when the user does not specify visual dimensions.

Default bias:
- type: `conceptual` for technical/system content
- palette: `cool` for engineering content
- rendering: `flat-vector` for clear modern covers
- text: `title-only`
- mood: `balanced`
- font: `clean`

## Prompt Construction

Save the prompt as `prompts/cover.md`.

Use [references/workflow/prompt-template.md](references/workflow/prompt-template.md) as the structure, but adapt it for Codex:
- keep it concise
- include only the elements needed for the current cover
- do not ask multiple rounds of questions when auto-selection is already good enough

## Generation

Preferred generation path:

```bash
bun skills/baoyu-imagine/scripts/main.ts --promptfiles prompts/cover.md --image cover.png --provider dashscope --model qwen-image-2.0-pro --ar 16:9
```

Any provider supported by `baoyu-imagine` is acceptable if credentials are available.

## Validation

A cover-image run is only considered validated when:
- the prompt file is saved
- the output image is saved
- the image matches the requested aspect ratio
- the result visually reflects the source content instead of looking generic
