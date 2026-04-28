---
name: baoyu-format-markdown
description: Clean up markdown typography and formatting, especially for Chinese/CJK content, then save the improved markdown file.
---

# baoyu-format-markdown

Use this skill when the user wants a markdown file cleaned up for readability without rewriting the content.

This Codex pilot focuses on the script-backed core:

- fix YAML/frontmatter formatting
- improve CJK punctuation and spacing behavior
- optionally replace ASCII quotes with fullwidth quotes
- save a cleaned markdown file

## Defaults

- Apply spacing fixes
- Apply emphasis fixes
- Keep content unchanged
- Use quotes conversion when the sample clearly benefits from it

## Workflow

1. Start from an existing markdown file.
2. Save a working copy if needed.
3. Run the formatter script with the chosen options.
4. Verify the markdown file still exists and shows the expected typography cleanup.
5. Optionally pass the formatted file into `baoyu-markdown-to-html`.

## Rules

- Do not rewrite the article content.
- Treat this as formatting and typography cleanup, not editing.
- Keep the first Codex validation local and deterministic.
