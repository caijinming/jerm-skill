---
name: baoyu-post-to-wechat
description: Prepare WeChat-ready article HTML from markdown, validate local publishing prerequisites, and use the original posting scripts when account credentials or browser login are available.
---

# baoyu-post-to-wechat

Use this skill when the user wants content prepared for WeChat Official Account publishing.

This Codex pilot validates the reliable local workflow first:

- convert markdown into WeChat-ready HTML
- run permission/environment checks
- verify config/credential resolution logic with tests

Real publishing is still supported by the original scripts, but it depends on account credentials or an already logged-in browser profile.

## Defaults

- Input: markdown article
- Output: temporary WeChat-ready HTML
- Citations: enabled by default
- Theme: default unless explicitly overridden

## Workflow

1. Convert markdown to WeChat-ready HTML with `md-to-wechat.ts`.
2. Run local checks with `check-permissions.ts`.
3. Run config-resolution tests.
4. If credentials or browser login are available, continue to real posting scripts.

## Rules

- Do not block the first Codex validation on account setup.
- Treat WeChat-ready HTML generation as the minimum meaningful pilot.
- Only claim “real publish verified” if an article is actually posted.
