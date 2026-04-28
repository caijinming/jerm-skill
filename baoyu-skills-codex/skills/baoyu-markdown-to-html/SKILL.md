---
name: baoyu-markdown-to-html
description: Convert a markdown file into a styled HTML file with a selectable theme, reusing the original local converter.
---

# baoyu-markdown-to-html

Use this skill when the user wants a markdown article converted into a styled HTML page for publishing, previewing, or repackaging.

This Codex pilot keeps the workflow compact:

- reuse the original converter script
- install local script dependencies if needed
- convert one markdown file to one HTML file
- verify the output file exists and looks structurally correct

## Defaults

- Theme: `default`
- Output path: same directory as input markdown file
- Title: from frontmatter or first heading

## Workflow

1. Take a markdown file as input.
2. Choose a theme if the user specified one; otherwise use `default`.
3. Run the local converter in `skills/baoyu-markdown-to-html/scripts/`.
4. Verify the generated `.html` file exists.
5. If needed, inspect the HTML head/body structure and report the output path.

## Rules

- Do not block on setup questions.
- Prefer direct conversion with sensible defaults.
- Keep the first Codex validation simple: single input file, single output file.

## Output

- `article.md` -> `article.html`
- If an older HTML file exists, the converter may create a timestamped backup first.
