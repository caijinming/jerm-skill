# First-Time Setup

Use this only when the user wants persistent preferences for future runs.

## Goal

Create `EXTEND.md` for `baoyu-url-to-markdown` without relying on Claude-specific interaction tools.

## Questions To Ask

Ask only what is needed, and keep it short.

1. Should media be downloaded by default?
- `ask`
- `always`
- `never`

2. What default output directory should be used?
- default: `./url-to-markdown/`
- or a custom path

3. Where should preferences be stored?
- project: `.baoyu-skills/baoyu-url-to-markdown/EXTEND.md`
- user: `$HOME/.baoyu-skills/baoyu-url-to-markdown/EXTEND.md`

## Template

```md
download_media: ask
default_output_dir: ./url-to-markdown/
```

## Guidance

- If the user does not care about persistence, skip setup and continue with one-off defaults.
- Do not ask multiple rounds of configuration questions when a one-off run is enough.
- Confirm the final save path after writing the file.
