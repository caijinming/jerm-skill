---
name: harmonyos-arkts-guide
description: Write, refactor, or review HarmonyOS ArkTS code using official Huawei guidance. Use when Codex needs ArkTS naming and formatting rules, safer coding defaults, or migration help for ArkTS-specific restrictions and unsupported TS/JS patterns in `.ets` and ArkTS-focused `.ts` code.
---

# HarmonyOS ArkTS Guide

## Overview

Apply Huawei's ArkTS coding-style guidance first, then load ArkTS special-case migration guidance only when the code or compiler requires it.
Keep the skill lean: use `references/coding-style.md` for baseline conventions and `references/more-cases.md` for unsupported or restricted patterns.

## Workflow

1. Inspect the repository for existing formatter, lint, and naming conventions.
2. Apply [references/coding-style.md](references/coding-style.md) for baseline naming, layout, control flow, and safe defaults.
3. Load [references/more-cases.md](references/more-cases.md) only when porting TS/JS code to ArkTS or when compiler/linter diagnostics indicate ArkTS-specific restrictions.
4. Prefer repository conventions when they are already consistent and compile cleanly.
5. Prefer local SDK and compiler diagnostics over older guidance when they conflict; mention the conflict briefly if it affects the answer.

## Reference Map

- Read [references/coding-style.md](references/coding-style.md) for naming, indentation, braces, quoting, array typing, and review defaults.
- Read [references/more-cases.md](references/more-cases.md) for migration rewrites around dynamic maps, `JSON.parse`, `this`, `bind`, `globalThis`, ArkTS module boundaries, and other unsupported TS/JS patterns.
- Do not load both reference files by default unless the task needs both style and migration guidance.

## Generate Code

- Preserve established project style when it is explicit.
- Default to 2-space indentation, single quotes, explicit braces, and readable line breaking when the repo has no stronger convention.
- Prefer explicit types, explicit ownership, and low-magic control flow.
- Prefer ArkTS-safe rewrites over clever TS/JS idioms when there is any compatibility risk.

## Review Code

- Prioritize findings in this order: correctness, ArkTS compatibility, maintainability, then style consistency.
- Call out the exact unsupported or risky pattern before suggesting a replacement.
- Use short "avoid / prefer" examples when they make the fix clearer.
- Treat compiler or linter rule names as the final locator when they are present.

## Maintain This Skill

- Keep `SKILL.md` short and procedural.
- Add new official guidance as separate files under `references/` instead of expanding this file into a large rule dump.
- Add source links and version notes inside each reference file so future updates stay localized.
