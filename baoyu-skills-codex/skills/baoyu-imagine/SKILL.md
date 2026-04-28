---
name: baoyu-imagine
description: Generate images with provider-backed APIs using a Codex-friendly workflow. Use when the user wants to create or iterate on images from prompts or references, especially when local provider selection, aspect ratio handling, or batch jobs matter.
---

# Imagine

This is the Codex pilot version of the original Baoyu image-generation skill.

## What Changed For Codex

- Removed hard dependence on Claude-only setup flows such as `AskUserQuestion`
- Treated persistent preferences as optional rather than a mandatory first-run blocker
- Preserved the local CLI and provider tests so the skill can be validated without live credentials
- Split validation into two layers: local test coverage first, live provider generation second

## Files

- Main skill file: `skills/baoyu-imagine/SKILL.md`
- CLI entry: `skills/baoyu-imagine/scripts/main.ts`
- Provider implementations: `skills/baoyu-imagine/scripts/providers/*.ts`
- Local tests: `skills/baoyu-imagine/scripts/main.test.ts` and `skills/baoyu-imagine/scripts/providers/*.test.ts`
- Preferences schema: `skills/baoyu-imagine/references/config/preferences-schema.md`

## Runtime

Use Bun to run the CLI or tests:

```bash
bun skills/baoyu-imagine/scripts/main.ts --prompt "A cat" --image ./tmp/cat.png
```

Local test command:

```bash
bun test skills/baoyu-imagine/scripts/main.test.ts skills/baoyu-imagine/scripts/providers/*.test.ts
```

## Preferences

Preferences are optional. Check these locations in order:

```bash
test -f .baoyu-skills/baoyu-imagine/EXTEND.md && echo project
test -f "${XDG_CONFIG_HOME:-$HOME/.config}/baoyu-skills/baoyu-imagine/EXTEND.md" && echo xdg
test -f "$HOME/.baoyu-skills/baoyu-imagine/EXTEND.md" && echo user
```

If an `EXTEND.md` file exists, read and apply it.

If none exists:
- do not block a one-off image task by default
- infer provider and model from CLI args or available environment variables
- only ask follow-up questions when the current run is ambiguous
- create persistent preferences only when the user explicitly wants defaults saved

Useful settings include:
- `default_provider`
- `default_quality`
- `default_aspect_ratio`
- `default_image_size`
- `default_model`

Schema reference: [references/config/preferences-schema.md](references/config/preferences-schema.md)

## Recommended Workflow

1. Check whether the user wants a one-off run or persistent defaults.
2. Resolve provider from CLI args, saved preferences, or available credentials.
3. Validate args locally before making any provider call.
4. If no provider credentials are available, use local tests to validate the skill wiring.
5. If credentials are available, generate one real image as the live verification step.
6. Save the result and report provider, model, output path, and any references used.

## Validation Levels

### Local validation

Run the built-in tests to verify:
- argument parsing
- provider selection
- request-body construction
- response extraction helpers
- batch and config behavior

### Live validation

Requires at least one provider credential such as:
- `OPENAI_API_KEY`
- `GOOGLE_API_KEY`
- `OPENROUTER_API_KEY`
- `DASHSCOPE_API_KEY`
- `ZAI_API_KEY`
- `MINIMAX_API_KEY`
- `REPLICATE_API_TOKEN`

When credentials are missing, do not claim that image generation has been fully validated.
