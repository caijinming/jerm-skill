---
name: baoyu-infographic
description: Generate infographic-style visual summaries with a Codex-friendly workflow. Use when the user wants a dense visual summary, visual explainer, information graphic, or structured poster generated from markdown, article content, or pasted notes.
---

# Infographic

This is the Codex pilot version of the original Baoyu infographic skill.

## What Changed For Codex

- Removed Claude-only `AskUserQuestion` assumptions
- Removed the mandatory first-run preferences blocker
- Collapsed the workflow into an executable path: analyze content, structure modules, build prompt, generate image
- Reused `baoyu-imagine` as the generation backend

## Files

- Main skill file: `skills/baoyu-infographic/SKILL.md`
- Base prompt: `skills/baoyu-infographic/references/base-prompt.md`
- Analysis guide: `skills/baoyu-infographic/references/analysis-framework.md`
- Structured content template: `skills/baoyu-infographic/references/structured-content-template.md`
- Layout definitions: `skills/baoyu-infographic/references/layouts/*.md`
- Style definitions: `skills/baoyu-infographic/references/styles/*.md`

## Dependencies

This skill depends on:
- `baoyu-imagine` for the actual image generation
- a provider credential for live generation

## Preferences

Preferences are optional. Check these locations in order:

```bash
test -f .baoyu-skills/baoyu-infographic/EXTEND.md && echo project
test -f "${XDG_CONFIG_HOME:-$HOME/.config}/baoyu-skills/baoyu-infographic/EXTEND.md" && echo xdg
test -f "$HOME/.baoyu-skills/baoyu-infographic/EXTEND.md" && echo user
```

If an `EXTEND.md` file exists, read and apply it.

If none exists:
- do not block the current run
- auto-select layout and style from the content
- ask one concise follow-up only if the user cares about a specific visual direction
- save defaults only when the user wants persistent preferences

## Recommended Workflow

1. Read the source content.
2. Identify the main topic, the viewer takeaways, and 4-6 information modules.
3. Choose a layout and style combination that matches the data structure.
4. Build a structured infographic prompt.
5. Generate the image through `baoyu-imagine`.
6. Save both the prompt and the output image.

## Default Bias

For technical or system content:
- layout: `dense-modules`
- style: `pop-laboratory`
- aspect: `16:9`

For more tutorial-like content:
- layout: `linear-progression`
- style: `technical-schematic` or `hand-drawn-edu`

## Prompt Assembly

Use these references as needed:
- `references/base-prompt.md`
- `references/analysis-framework.md`
- `references/structured-content-template.md`
- the chosen file under `references/layouts/`
- the chosen file under `references/styles/`

Keep the generated prompt focused on:
- layout structure
- style constraints
- exact section/module labels
- the main learning objective of the content

## Generation

Preferred execution path:

```bash
bun skills/baoyu-imagine/scripts/main.ts --promptfiles prompts/infographic.md --image infographic.png --provider dashscope --model qwen-image-2.0-pro --ar 16:9
```

## Validation

An infographic run is only considered validated when:
- the prompt file is saved
- the output image is saved
- the selected layout is reflected in the generated composition
- the image reads like a visual summary of the source rather than a generic poster
