# First-Time Setup

Use this only when the user wants persistent translation defaults.

## Goal

Create `EXTEND.md` for `baoyu-translate` without depending on Claude-only interaction primitives.

## Questions To Ask

Keep the setup short and only ask what matters for future runs.

1. Default target language
- example: `zh-CN`, `en`, `ja`

2. Default translation mode
- `quick`
- `normal`
- `refined`

3. Default audience
- `general`
- `technical`
- `academic`
- `business`
- or a short custom audience description

4. Default style
- `storytelling`
- `formal`
- `technical`
- `literal`
- `academic`
- `business`
- `humorous`
- `conversational`
- `elegant`

5. Save location
- project: `.baoyu-skills/baoyu-translate/EXTEND.md`
- user: `$HOME/.baoyu-skills/baoyu-translate/EXTEND.md`

## Template

```yaml
target_language: zh-CN
default_mode: normal
audience: general
style: storytelling
```

## Guidance

- Skip setup when a one-off translation is enough.
- Do not force a long preference interview before the first useful result.
- Confirm the save path after writing the file.
