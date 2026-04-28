---
name: baoyu-diagram
description: Create a professional SVG diagram from a concept, then export a high-resolution PNG preview.
---

# baoyu-diagram

Use this skill when the user wants a diagram, architecture view, flowchart, process visualization, or conceptual structure rendered as a standalone SVG.

This Codex pilot focuses on the most testable path:

- generate one architecture-style SVG
- save it locally
- export a `@2x` PNG with the provided converter

## Defaults

- Diagram type: `architecture`
- Theme: dark technical editorial
- Output pair: `.svg` + `@2x.png`

## Workflow

1. Extract the system or workflow to visualize.
2. Choose the simplest fitting diagram type.
3. Save a self-contained SVG.
4. Run `scripts/main.ts` to export `@2x` PNG.
5. Verify both files exist and dimensions are sensible.

## Rules

- Prefer clear structure over density.
- Use a valid `viewBox`.
- Keep labels concise.
- Save the SVG before conversion.
- For Chinese labels, allow wider boxes and readable font fallbacks.

## Output Structure

Suggested output directory:

`tmp/diagram-codex/`

Typical contents:

- `codex-workflow-architecture.svg`
- `codex-workflow-architecture@2x.png`

## References

- `references/architecture.md`
- `references/flowchart.md`
