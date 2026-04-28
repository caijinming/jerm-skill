---
name: baoyu-danger-x-to-markdown
description: Fetch an X post, thread, or X article into local markdown with frontmatter, optionally localize remote media, and reuse the browser-backed X session flow when cookies are needed.
---

# baoyu-danger-x-to-markdown

Use this skill when the user wants X or Twitter content saved locally as markdown.

This Codex pilot keeps the workflow narrow and practical:

- fetch one tweet, thread, or X article into markdown
- preserve frontmatter and local cache layout
- optionally localize remote image and video URLs into local files
- reuse browser-backed X cookies when direct env cookies are unavailable

## Defaults

- Save into `./x-to-markdown/` unless the user gives an explicit output path.
- Keep the first Codex validation to one URL at a time.
- Prefer plain markdown export first.
- Use `--download-media` only when the user explicitly wants local image/video files.

## Workflow

1. Take one X URL.
2. Reuse an existing consent file if present; otherwise ask for consent in normal language and record it before continuing.
3. Run the local converter script.
4. If X cookies are missing, refresh them from the shared Chrome profile.
5. Return the markdown path and any localized media directories.

## Rules

- Do not claim this is using an official X API. It is not.
- Treat this as a volatile integration. X can break it at any time.
- Prefer one deterministic fetch first before trying media download or repeated retries.
- Reuse the shared browser session path already proven by `baoyu-post-to-x` when cookies must come from Chrome.
- Only say “real fetch verified” after a real X URL has been converted successfully.
