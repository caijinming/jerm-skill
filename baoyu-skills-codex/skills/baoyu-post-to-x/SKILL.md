---
name: baoyu-post-to-x
description: Prepare X-ready article HTML from markdown, validate local browser/posting prerequisites, and reuse the original browser posting scripts when an X session is available.
---

# baoyu-post-to-x

Use this skill when the user wants content prepared for X posts or X Articles.

This Codex pilot validates the local workflow first:

- convert markdown into X-ready HTML
- run permission/environment checks
- run session/tooling unit tests

Real posting is still supported by the original scripts, but it depends on an already logged-in X browser profile.

## Defaults

- Input: markdown article
- Output: temporary X-ready HTML
- Keep the first Codex validation local and deterministic

## Workflow

1. Convert markdown to X-ready HTML with `md-to-html.ts`.
2. Run `check-paste-permissions.ts`.
3. Run `x-utils.test.ts`.
4. If a valid X session exists in the browser profile, continue with `x-browser.ts` or `x-article.ts`.

## Rules

- Do not claim “real post verified” unless a compose/publish flow actually succeeds in X.
- Treat HTML generation plus environment readiness as the minimum meaningful pilot when no session is configured.
