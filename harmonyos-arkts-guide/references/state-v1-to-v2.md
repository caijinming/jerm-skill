# ArkUI State Management V1 to V2 Reference

Sources:
- Huawei official guide, ArkUI state management overview: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-state-management-overview
- Huawei official guide, ArkTS coding style: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-coding-style-guide
- Huawei official HarmonyOS guides for V2 decorators such as `@ComponentV2`, `@ObservedV2`, and `@Trace`; verify the exact page and API names against the installed SDK docs.

Use this file when upgrading ArkUI state management V1 code to V2 in `.ets` components and related ArkTS models. Keep the local SDK, compiler, and linter as the source of truth because V2 APIs and diagnostics can vary by HarmonyOS release.

## Migration Posture

- Preserve behavior first, then improve style.
- Identify state ownership before changing decorators.
- Convert related parent, child, and model files together; state contracts usually cross component boundaries.
- Avoid blind one-to-one decorator replacement. V1 and V2 often encode different ownership and synchronization semantics.
- Prefer explicit event callbacks for child-to-parent updates unless the V2 API in the local SDK provides a clearer supported binding.
- Do not mix V1 and V2 state decorators inside the same component unless local documentation and compiler diagnostics confirm the pattern is supported.
- Treat V1/V2 mixing as a temporary migration boundary. The goal is to keep each boundary explicit and testable until the surrounding subtree is migrated.

## Mixed V1 and V2 Risk Control

Incremental migration is expected in large projects. The main risk is not that V1 and V2 appear in the same repository; the risk is that one state contract crosses the V1/V2 boundary while each side expects different update, observation, or ownership semantics.

### High-risk mixed patterns

- Same component or same observed model class contains both V1 and V2 state decorators.
- A V1 parent writes into a V2 child as if `@Link` semantics still apply.
- A V2 child mutates data received from a V1 parent without an explicit event or shared model contract.
- V1 `@Observed` objects are passed into V2 code that expects `@ObservedV2` plus `@Trace` field-level tracking.
- V2 `@ObservedV2` models are passed back into V1 code that expects V1 object observation behavior.
- `@Provide` / `@Consume` and `@Provider` / `@Consumer` are mixed across the same dependency path without a local SDK-supported pattern.
- V1 storage decorators and V2 app/local/persistence state APIs point at the same logical value, creating two sources of truth.
- `@Watch` side effects and V2 monitor-style side effects both update the same state, creating duplicate writes or ordering-dependent behavior.

### Safer incremental boundaries

- Keep migrated and unmigrated state decorators out of the same component whenever possible.
- Use plain typed parameters for parent-to-child data at the boundary.
- Use explicit callback events for child-to-parent updates at the boundary.
- Use a small adapter component when a V1 parent must host a V2 child, or a V2 parent must host a V1 child.
- Keep one side as the source of truth; the other side should receive snapshots or send events.
- Normalize observed models at the boundary: either keep the model V1 until the whole subtree migrates, or convert it to V2 and update every consumer in the same migration group.
- For storage, choose one state API as authoritative and bridge reads/writes through a typed service or helper until all consumers migrate.

Avoid using decorator semantics as the boundary contract:

```ts
// Risky: migration relies on two-way decorator behavior crossing V1/V2 code.
@Link selectedId: string
```

Prefer an explicit boundary:

```ts
@Param selectedId: string = ''
@Event onSelectedIdChange: (selectedId: string) => void = () => {}
```

### Migration islands

Plan each batch as a migration island:

1. Pick one page, component subtree, or shared model with clear callers.
2. List every state contract entering or leaving the island.
3. Decide which boundary values are snapshots, callbacks, shared models, services, or storage keys.
4. Migrate internal components and models together.
5. Keep adapters at the island boundary until adjacent areas migrate.
6. Remove adapters when both sides are V2 and the state contract is stable.

Do not split a single two-way state relationship across batches unless the boundary is rewritten to explicit params and events first.

## Audit Commands

If this skill's bundled scripts are available, start with:

```bash
python3 scripts/audit_state_v1.py <project-root>
python3 scripts/audit_state_v1.py <project-root> --json
```

The script reports V1 and V2 decorator hits, then assigns file-level migration priority:

- `high`: mixed V1/V2, two-way state, observed model, or storage state risk.
- `medium`: dependency injection or watcher/monitor risk.
- `low`: V1 remains, but the file appears to use simpler local state patterns.
- `v2-only`: V2 decorators found without V1 decorators in that file.

Use the risk labels to choose the next migration island:

- `mixed-file`: V1 and V2 decorators appear in the same file.
- `mixed-v2-nearby`: a V1 decorator appears near V2 decorators.
- `two-way-state`: `@Link` or `@ObjectLink` exists; protect update direction before changing decorators.
- `observed-model`: V1/V2 observed model semantics need review.
- `storage-state`: storage or environment state may affect app-wide behavior.
- `dependency-injection`: provider/consumer semantics need local SDK verification.
- `watch-or-monitor`: side-effect ordering can change during migration.

Use repository-local search when the script is not available or when investigating a specific pattern:

```bash
rg -n "@(Component|State|Prop|Link|ObjectLink|Provide|Consume|Observed|Watch|StorageLink|StorageProp|LocalStorageLink|LocalStorageProp|LocalStorage|AppStorage|Environment)\b" -g '*.ets' -g '*.ts'
rg -n "@Observed\b|class .*\{" -g '*.ets' -g '*.ts'
rg -n "@Watch\(|StorageLink\(|StorageProp\(" -g '*.ets' -g '*.ts'
```

Classify every hit as one of these before rewriting:

- component-owned local mutable state
- parent-provided input
- child-to-parent event or edit
- shared dependency or service
- app/global/persistent state
- observed object model
- derived or watched state

Treat script results such as `mixed-v2-nearby`, `mixed-file`, `two-way-state`, `observed-model`, and `storage-state` as review hotspots. They may be valid during incremental migration, but they deserve boundary checks and compiler verification before more edits are made.

## Typical V1 to V2 Decisions

Treat this as a decision table, not a mechanical map.

| V1 pattern | V2 direction | Check before changing |
| --- | --- | --- |
| `@Component` | `@ComponentV2` | Convert the component's state decorators in the same pass. |
| `@State` | `@Local` | Use for component-owned mutable state that does not need direct parent writes. |
| `@Prop` | `@Param`, or `@Once` with `@Param` for one-time initialization when supported | Confirm whether parent updates must keep flowing into the child. |
| `@Link` | `@Param` plus `@Event`, or an explicit shared model | Preserve two-way behavior; do not silently make it one-way. |
| `@ObjectLink` | `@Param` with an `@ObservedV2` model, or explicit event callbacks | Verify nested property updates still trigger rendering. |
| `@Provide` / `@Consume` | `@Provider` / `@Consumer` when available | Confirm naming, aliasing, and lifecycle in the local SDK. |
| `@Observed` | `@ObservedV2` plus `@Trace` on reactive fields | Add tracing only to fields that UI or dependent state must observe. |
| `@Watch` | `@Monitor` or explicit update code when supported | Keep side effects narrow; avoid using watchers to patch broken data flow. |
| `@StorageLink` / `@StorageProp` / `@LocalStorageLink` / `@LocalStorageProp` | V2 app, local, or persistence state APIs when available | Check persistence scope and initial-value behavior manually. |

## Recommended Rewrite Flow

1. Inventory V1 and mixed V1/V2 decorators with the script or `rg`.
2. Group files into migration islands by page, component subtree, shared model, or storage key.
3. Mark every island boundary as snapshot input, callback output, shared model, service, or storage.
4. Convert model classes first when they use `@Observed` and all consumers in the island can move together.
5. Convert leaf child components, then parents.
6. Replace two-way links with explicit params and events unless a supported V2 binding is already used in the repo.
7. Rebuild or run the ArkTS checker.
8. Fix compiler diagnostics before continuing to the next subtree.

## Observed Model Rewrite

V1 code often relies on broad object observation. In V2, make observed fields explicit.

Avoid leaving model changes implicit:

```ts
@Observed
class UserProfile {
  name: string = ''
  age: number = 0
}
```

Prefer explicit V2 observation when the local SDK supports it:

```ts
@ObservedV2
class UserProfile {
  @Trace name: string = ''
  @Trace age: number = 0
}
```

Only mark fields with `@Trace` when changes should participate in UI refresh or dependent state updates. Keep non-reactive caches, service references, and derived temporaries untraced unless the UI depends on them.

## Parent and Child State Contracts

For each child component input, decide the real contract:

- One-time initialization: pass a value once; child owns later edits.
- Parent-driven input: parent updates should refresh the child.
- Child edit: child should notify parent through an event callback.
- Shared model: both sides mutate an observed model with explicit traced fields.

Do not collapse these contracts into a single decorator just because it compiles. Most migration regressions come from accidentally changing one-way data into local state, or two-way data into stale input.

## Persistence and Global State

Handle app-level state separately from component state:

- Inventory `AppStorage`, `LocalStorage`, `PersistentStorage`, and `Environment` usage before editing.
- Confirm whether the value is truly global, page-local, session-local, or persisted across launches.
- Prefer small typed state holders over stringly typed global keys when creating new V2 code.
- Preserve migration keys and default values unless the user explicitly requests a storage schema change.

## Validation Checklist

- The component uses V2 state decorators consistently.
- Parent-to-child updates still refresh the child when required.
- Child edits still reach the parent when required.
- Observed model fields that affect UI are marked for V2 tracing.
- Non-reactive fields are not accidentally made reactive.
- Storage and persistence semantics match the original behavior.
- Compiler or linter diagnostics are fixed, not suppressed.
- A local build, preview compile, or ArkTS checker was run when available.

## When to Stop and Ask

Ask for user input instead of guessing when:

- the code depends on a HarmonyOS SDK version that is not installed locally;
- the same component mixes V1 and V2 APIs in a way the compiler accepts but documentation is unclear about;
- a V1 `@Link` or storage value has ambiguous ownership and no tests or usage sites clarify it;
- migration would require changing persisted data shape or public component APIs.
