---
name: harmonyos-arkts-guide
description: Write, refactor, review, or migrate HarmonyOS ArkTS code using official Huawei guidance. Use when Codex needs ArkTS naming and formatting rules, safer coding defaults, migration help for ArkTS-specific restrictions and unsupported TS/JS patterns, or ArkUI state management V1-to-V2 upgrades in `.ets` and ArkTS-focused `.ts` code.
---

# HarmonyOS ArkTS Guide

## Overview

Apply Huawei's ArkTS coding-style guidance first, then load migration guidance only when the code or compiler requires it.
Keep the skill lean: use `references/coding-style.md` for baseline conventions, `references/more-cases.md` for unsupported or restricted TS/JS patterns, and `references/state-v1-to-v2.md` for ArkUI state management V1-to-V2 upgrades.

## Workflow

1. Inspect the repository for existing formatter, lint, and naming conventions.
2. Apply [references/coding-style.md](references/coding-style.md) for baseline naming, layout, control flow, and safe defaults.
3. Load [references/more-cases.md](references/more-cases.md) only when porting TS/JS code to ArkTS or when compiler/linter diagnostics indicate ArkTS-specific restrictions.
4. Load [references/state-v1-to-v2.md](references/state-v1-to-v2.md) when upgrading ArkUI state management V1 decorators, components, observed models, or mixed V1/V2 state code to V2.
5. For V1-to-V2 upgrades, run `scripts/audit_state_v1.py <project-root>` when a project tree is available, then use the report to plan migration groups.
6. Prefer repository conventions when they are already consistent and compile cleanly.
7. Prefer local SDK and compiler diagnostics over older guidance when they conflict; mention the conflict briefly if it affects the answer.

## Reference Map

- Read [references/coding-style.md](references/coding-style.md) for naming, indentation, braces, quoting, array typing, and review defaults.
- Read [references/more-cases.md](references/more-cases.md) for migration rewrites around dynamic maps, `JSON.parse`, `this`, `bind`, `globalThis`, ArkTS module boundaries, and other unsupported TS/JS patterns.
- Read [references/state-v1-to-v2.md](references/state-v1-to-v2.md) for ArkUI state management V1-to-V2 audits, mixed V1/V2 risk control, decorator selection, observed model rewrites, and validation steps.
- Use [scripts/audit_state_v1.py](scripts/audit_state_v1.py) to inventory ArkUI state management V1 decorators before editing a real project.
- Do not load every reference file by default; choose only the file needed by the current task.

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

## Upgrade ArkUI State V1 to V2

- First identify the state ownership and synchronization contract, then choose V2 decorators.
- Start from the audit script output when source files are available; it finds V1 decorators and flags nearby V2 mixing.
- Treat mixed V1/V2 as an incremental migration state, not as a target architecture.
- Prefer explicit adapter boundaries between migrated and unmigrated areas: plain params, callbacks, typed models, or services instead of shared decorator semantics crossing the boundary.
- Do not mechanically replace every V1 decorator by name; preserve parent-child update direction, two-way edits, object observation depth, and persistence behavior.
- Migrate in small groups of related components and run the local build/checker after each group when possible.
- Keep V1 and V2 state patterns separated inside a component unless the local SDK documentation explicitly supports the mix.

## Maintain This Skill

- Keep `SKILL.md` short and procedural.
- Add new official guidance as separate files under `references/` instead of expanding this file into a large rule dump.
- Add source links and version notes inside each reference file so future updates stay localized.
