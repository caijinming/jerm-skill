---
name: baoyu-youtube-transcript
description: Fetch a YouTube video's transcript, metadata, and cover image into a local cache directory, then save a readable transcript file.
---

# baoyu-youtube-transcript

Use this skill when the user wants a YouTube transcript, subtitles, captions, metadata, or thumbnail saved locally.

This Codex pilot focuses on the most useful minimal path:

- fetch one real YouTube transcript
- save metadata and cover image
- save a markdown transcript
- reuse the built-in cache structure

## Defaults

- Output format: markdown
- Language priority: English unless the user specifies otherwise
- Keep timestamps on
- Save into a local cache directory

## Workflow

1. Take a YouTube URL or video ID.
2. Run the local transcript script.
3. Save or reuse cached raw data.
4. Return the transcript file path and supporting artifacts.

## Rules

- Always quote full YouTube URLs when calling the script from zsh.
- Prefer a direct fetch first.
- Use fallback tooling only if the direct fetch path is blocked.
- Keep the first Codex validation simple: one video, one transcript output.
