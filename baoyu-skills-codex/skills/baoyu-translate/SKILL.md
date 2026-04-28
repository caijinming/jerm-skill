---
name: baoyu-translate
description: Translate articles or markdown documents with a Codex-friendly workflow. Use when the user wants to translate a file, URL content, or pasted article into another language, especially when chunking, glossary handling, or a more careful rewrite is useful.
---

# Translator

This is the Codex pilot version of the original Baoyu translation skill.

## What Changed For Codex

- Removed Claude-specific `AskUserQuestion` assumptions
- Removed default dependence on subagents for chunk translation
- Kept the local chunking helper so the workflow is still executable and testable
- Treated persistent preferences as optional instead of blocking every first run

## Files

- Main skill file: `skills/baoyu-translate/SKILL.md`
- Chunk CLI entry: `skills/baoyu-translate/scripts/main.ts`
- Chunk implementation: `skills/baoyu-translate/scripts/chunk.ts`
- Built-in glossary: `skills/baoyu-translate/references/glossary-en-zh.md`
- Setup notes: `skills/baoyu-translate/references/config/first-time-setup.md`

## Runtime

Resolve the Bun runtime once before execution:

```bash
if command -v bun >/dev/null 2>&1; then
  BUN_X="bun"
elif command -v npx >/dev/null 2>&1; then
  BUN_X="npx -y bun"
else
  echo "Install bun first: brew install oven-sh/bun/bun"
  exit 1
fi
```

Chunk helper:

```bash
${BUN_X} skills/baoyu-translate/scripts/main.ts <file> --output-dir <dir>
```

## Preferences

Preferences are optional. Check these locations in order:

```bash
test -f .baoyu-skills/baoyu-translate/EXTEND.md && echo project
test -f "${XDG_CONFIG_HOME:-$HOME/.config}/baoyu-skills/baoyu-translate/EXTEND.md" && echo xdg
test -f "$HOME/.baoyu-skills/baoyu-translate/EXTEND.md" && echo user
```

If a preferences file exists, read and apply it.

If none exists:
- do not block the task by default
- use one-off translation settings for the current run
- ask only the minimum follow-up needed for the current output
- use [references/config/first-time-setup.md](references/config/first-time-setup.md) only when the user wants persistent defaults

Useful keys:
- `target_language`
- `default_mode`
- `audience`
- `style`
- `glossary`
- `glossary_files`

Schema reference: [references/config/extend-schema.md](references/config/extend-schema.md)

## Recommended Workflow

1. Resolve source material and output location.
2. Load preferences only if they exist or the user asks to save them.
3. For short content, translate directly in one pass.
4. For longer markdown, run the chunk helper first.
5. Translate sequentially by default.
6. If parallel delegation is explicitly available and worthwhile, it is optional, not required.
7. Review the merged translation for tone, terminology, and markdown integrity.

## Chunking

For markdown that is long enough to risk context drift or terminology inconsistency, use the chunk helper:

```bash
${BUN_X} skills/baoyu-translate/scripts/main.ts article.md --output-dir ./translate-run --max-words 5000
```

This writes chunks under `./translate-run/chunks/`.

Use the chunk helper to validate the local workflow even before full translation automation exists.

## Translation Principles

- Rewrite naturally in the target language instead of translating word-for-word.
- Keep facts, links, code blocks, and markdown structure intact.
- Maintain terminology consistency across chunks.
- Add brief clarification only when the target audience genuinely needs it.
- Treat chunking as a quality aid, not a requirement for every document.
