# AGENTS.md

This repository is a Codex-only pilot for skill migration.

## Intent

- Optimize for fast validation, not completeness
- Keep each migration step small and reversible
- Prefer one working Codex-native skill over many partially migrated skills
- Remove Claude/OpenClaw-specific assumptions instead of trying to preserve them

## Repository Rules

- Skills live under `skills/<skill-name>/`
- Each skill should contain `SKILL.md` and may contain `agents/`, `references/`, and `scripts/`
- Prefer Codex-native instructions: concise questions, explicit local commands, and fallback paths when optional tooling is unavailable
- Do not depend on Claude-specific primitives such as `AskUserQuestion`, `/plugin`, or command-slash invocation patterns
- Do not assume subagents are available; workflows must still work sequentially

## Pilot Standard

A pilot skill is good enough only if:
- Codex can infer when to use it from its `description`
- the workflow is executable from local files and commands
- the skill improves output quality or operator speed in a noticeable way
