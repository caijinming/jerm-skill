---
name: baoyu-url-to-markdown
description: Fetch a URL and convert it to markdown using the local baoyu-fetch CLI. Use when the user wants to save a webpage, article, X thread, YouTube page, or Hacker News thread as markdown, especially when the page may need browser rendering, login, or interaction.
---

# URL To Markdown

This is the Codex pilot version of the original Baoyu skill.

## What Changed For Codex

- Removed Claude/OpenClaw-specific installation and invocation assumptions
- Removed hard dependency on `AskUserQuestion`
- Defaulted the workflow to plain user questions when preferences are missing
- Treated interactive/browser steps as optional fallbacks, not UI primitives

## Files

- Main skill file: `skills/baoyu-url-to-markdown/SKILL.md`
- CLI package file: `skills/baoyu-url-to-markdown/scripts/package.json`
- Vendored CLI source: `skills/baoyu-url-to-markdown/scripts/vendor/baoyu-fetch/src/cli.ts`
- First-time setup notes: `skills/baoyu-url-to-markdown/references/config/first-time-setup.md`

## Runtime

Resolve the Bun runtime once before execution:

```bash
if command -v bun >/dev/null 2>&1; then
  BUN_X="bun"
elif command -v npx >/dev/null 2>&1; then
  BUN_X="npx -y bun"
else
  echo "Install bun first: brew install oven-sh/bun/bun or npm install -g bun"
  exit 1
fi
```

CLI entry point:

```bash
${BUN_X} skills/baoyu-url-to-markdown/scripts/vendor/baoyu-fetch/src/cli.ts <url>
```

## Preferences

Preferences are optional. Check these locations in order:

```bash
test -f .baoyu-skills/baoyu-url-to-markdown/EXTEND.md && echo project
test -f "${XDG_CONFIG_HOME:-$HOME/.config}/baoyu-skills/baoyu-url-to-markdown/EXTEND.md" && echo xdg
test -f "$HOME/.baoyu-skills/baoyu-url-to-markdown/EXTEND.md" && echo user
```

If an `EXTEND.md` file exists, read and apply it.

If no preferences file exists:
- do not block the entire task unless the user clearly wants persistent defaults
- use sensible one-off behavior for the current run
- ask at most one concise follow-up question only when it affects the current output path or media download behavior
- if the user wants persistence, follow [references/config/first-time-setup.md](references/config/first-time-setup.md)

Supported keys:
- `download_media`: `ask`, `1`, or `0`
- `default_output_dir`: a base output directory

## Recommended Workflow

1. Inspect whether `EXTEND.md` exists.
2. Resolve the output path.
3. Run headless first unless there is already a clear reason to use interaction mode.
4. Review the markdown output instead of trusting process exit alone.
5. If the result is low quality, retry with interaction mode.

## Output Path Rules

If the user gives an explicit output path, use it.

Otherwise:
- if `default_output_dir` exists, write under that directory
- else default to `./url-to-markdown/<domain>/<slug>.md`

If media download is enabled, ensure an output file path is provided.

## Common Commands

```bash
${BUN_X} skills/baoyu-url-to-markdown/scripts/vendor/baoyu-fetch/src/cli.ts <url> --output article.md
${BUN_X} skills/baoyu-url-to-markdown/scripts/vendor/baoyu-fetch/src/cli.ts <url> --output article.md --download-media
${BUN_X} skills/baoyu-url-to-markdown/scripts/vendor/baoyu-fetch/src/cli.ts <url> --wait-for interaction --output article.md
${BUN_X} skills/baoyu-url-to-markdown/scripts/vendor/baoyu-fetch/src/cli.ts <url> --format json --output article.json
```

## Quality Gate

After each run, inspect the saved markdown and reject obviously bad captures.

Watch for:
- generic site shell instead of the target page
- login or paywall content instead of the article body
- extremely short markdown for a page that should be substantial
- boilerplate-heavy output that suggests headless capture was incomplete

If output quality is poor, rerun with interaction mode before concluding the tool failed.
