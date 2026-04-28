---
name: baoyu-article-illustrator
description: Analyze an article, identify a few illustration opportunities, save prompt files, and render supporting visuals for the article.
---

# baoyu-article-illustrator

Use this skill when the user wants to add illustrations to an article, explain a concept visually, or generate a small set of supporting images for a post.

This Codex pilot focuses on a compact, testable workflow:

- analyze one article
- pick 2 valuable illustration slots
- save `outline.md`
- save prompt files before generation
- render 2 supporting images with `baoyu-imagine`

## Defaults

- Density: balanced-light (2 illustrations)
- Type mix: framework + flowchart
- Style: `blueprint`
- Palette: default or `warm`
- Aspect ratio: `16:9`

## Workflow

1. Read the article and extract 2 illustration-worthy ideas.
2. Save an `outline.md` describing position, purpose, type, and filename.
3. Save one prompt file per illustration in `prompts/`.
4. Render each prompt with `baoyu-imagine`.
5. Keep output paths stable so the images can be inserted into the article later.

## Rules

- Save prompt files before any image generation.
- Prefer diagrams and conceptual visuals over literal screenshots.
- Use article-specific language and concepts in labels.
- Keep the illustration set stylistically consistent.

## Output Structure

Suggested output directory:

`tmp/article-illustrator-codex/`

Typical contents:

- `outline.md`
- `prompts/01-*.md`
- `prompts/02-*.md`
- `01-*.png`
- `02-*.png`

## References

- `references/style-presets.md`
- `references/prompt-construction.md`
- `references/styles/blueprint.md`
