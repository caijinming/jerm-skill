# First-Time Setup

Use this only when the user wants persistent image-generation defaults.

## Goal

Create `EXTEND.md` for `baoyu-imagine` without depending on Claude-specific UI primitives.

## Questions To Ask

Ask only what is needed for future runs:

1. Default provider
- `google`
- `openai`
- `azure`
- `openrouter`
- `dashscope`
- `zai`
- `minimax`
- `replicate`

2. Default model for that provider

3. Default quality
- `normal`
- `2k`

4. Save location
- project: `.baoyu-skills/baoyu-imagine/EXTEND.md`
- user: `$HOME/.baoyu-skills/baoyu-imagine/EXTEND.md`

## Guidance

- Skip setup when the user only wants one image right now.
- Do not block one-off generation just because no defaults file exists.
- If there is no provider credential available, say that setup can still be saved but live generation will remain unverified.
