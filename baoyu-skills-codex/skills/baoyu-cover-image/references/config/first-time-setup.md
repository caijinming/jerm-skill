# First-Time Setup

Use this only when the user wants persistent cover-generation defaults.

## Goal

Create `EXTEND.md` for `baoyu-cover-image` without using Claude-only UI tools.

## Questions To Ask

Ask only what is worth reusing:

1. Preferred type
- `auto`
- `hero`
- `conceptual`
- `typography`

2. Preferred palette
- `auto`
- `cool`
- `elegant`
- `warm`

3. Preferred rendering
- `auto`
- `flat-vector`
- `digital`
- `hand-drawn`

4. Default aspect ratio
- `16:9`
- `2.35:1`
- `1:1`
- `3:4`

5. Save location
- project: `.baoyu-skills/baoyu-cover-image/EXTEND.md`
- user: `$HOME/.baoyu-skills/baoyu-cover-image/EXTEND.md`

## Guidance

- Skip setup when the user just wants one cover now.
- Do not force a long preference interview before the first useful image.
- If image-generation credentials are missing, the setup can still be saved, but live cover generation remains unverified.
