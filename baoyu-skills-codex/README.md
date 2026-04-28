# baoyu-skills-codex

Codex-first pilot repository for validating whether Baoyu skills are worth migrating from the Claude/OpenClaw workflow.

This repo is intentionally small.

Current scope:
- pilot 1: `baoyu-url-to-markdown`
- pilot 2: `baoyu-translate`
- pilot 3: `baoyu-imagine`
- pilot 4: `baoyu-cover-image`
- pilot 5: `baoyu-infographic`
- pilot 6: `baoyu-image-cards`
- pilot 7: `baoyu-slide-deck`
- one goal: verify trigger quality, instruction quality, and local execution flow in Codex

## Validation Rules

Stop the migration if the pilot does not show clear value in Codex on these checks:
- the skill triggers from natural language reliably
- Codex follows the workflow without Claude-specific UI assumptions
- the local script path is understandable and executable
- the output quality is better or faster than using Codex without the skill

## Pilot Skills

`baoyu-url-to-markdown`
- fetches a URL into markdown using `baoyu-fetch`
- covers local script execution, preference loading, and output quality checks
- is simpler than the image and publishing workflows, so it is a good first gate

`baoyu-translate`
- validates a longer workflow without assuming Claude-only UI primitives
- keeps local markdown chunking as an executable helper
- is the second gate for whether Codex can handle richer content workflows

`baoyu-imagine`
- validates a generation-oriented skill without forcing Claude-specific setup flows
- keeps provider logic and local tests executable in Codex
- separates local verification from live-provider verification when API keys are absent

`baoyu-cover-image`
- validates a higher-level orchestration skill on top of `baoyu-imagine`
- converts article content into a structured cover prompt
- tests whether Codex can handle prompt assembly and generation without Claude-specific UI tools

`baoyu-infographic`
- validates a denser visual-structure skill on top of `baoyu-imagine`
- turns article content into structured modules and labels
- tests whether Codex can handle layout-driven prompt assembly for publication-style visuals

`baoyu-image-cards`
- validates multi-image social-card generation on top of `baoyu-imagine`
- turns article content into a small image-card series
- tests whether Codex can handle repeated prompt generation within one skill run

`baoyu-slide-deck`
- validates multi-slide deck generation plus merge outputs
- turns article content into a 3-slide mini deck
- tests whether Codex can handle outline-driven prompts and artifact bundling

## Suggested Test Prompts

- `Use $baoyu-url-to-markdown to save https://example.com as markdown.`
- `Fetch this article into markdown and store it locally: https://example.com/article`
- `Read this page with baoyu-url-to-markdown and inspect whether the output is clean enough.`

## Next Step If Pilot Works

If these two pilots feel materially useful, migrate a generation skill next:
- `baoyu-cover-image`
- or `baoyu-imagine`


## Fast Test

Run the repository doctor first:

```bash
npm run doctor
```

Then run the pilot skill against a simple page:

```bash
npm run test:url-to-markdown -- https://example.com ./tmp/example.md
```

If `bun` is not installed globally, the first run may need to fetch it through `npx`.

Run the translate chunk smoke test:

```bash
npm run test:translate-chunk -- ./tmp/sample.md ./tmp/translate-check
```

The first translate run installs `skills/baoyu-translate/scripts` dependencies automatically if needed.

Run the imagine local smoke test:

```bash
npm run test:imagine
```

This runs local unit tests only. Real image generation still requires a provider API key.

Run the cover-image smoke test:

```bash
npm run test:cover-image -- ./tmp/codex-best-practices.md
```

This builds a real cover prompt from article content and generates a cover image through `baoyu-imagine`.

Run the infographic smoke test:

```bash
npm run test:infographic -- ./tmp/codex-best-practices.md
```

This builds a real infographic prompt from article content and generates an infographic image through `baoyu-imagine`.

Run the image-cards smoke test:

```bash
npm run test:image-cards -- ./tmp/codex-best-practices.md
```

This builds a 3-card mini series and generates all images through `baoyu-imagine`.

Run the slide-deck smoke test:

```bash
npm run test:slide-deck -- ./tmp/codex-best-practices.md
```

This builds a 3-slide mini deck, generates slide images, and merges them into both `.pptx` and `.pdf`.
