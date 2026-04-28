# ArkTS More Cases Reference

Source:
- Huawei official guide: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-more-cases

Use this file when normal TypeScript or JavaScript patterns fail in ArkTS, especially during migration from TS/JS to `.ets` or ArkTS-oriented `.ts` code.

## Migration Posture

- Rewrite dynamic patterns toward explicit types, explicit ownership, and explicit module boundaries.
- Trust the local ArkTS compiler, SDK, and linter over older examples when behavior differs.
- Use compiler or linter rule names as the most precise fix anchor when they are available.

## Common Rewrites

### Dynamic key-value objects

- Do not rely on TS indexed signatures as the default representation for map-like data.
- Prefer `Record<string, T>` for dictionary-like objects.
- Prefer explicit interfaces or classes when keys are known in advance.
- Prefer arrays only for ordered numeric collections.

Avoid:

```ts
interface StringMap {
  [key: string]: string
}
```

Prefer:

```ts
type StringMap = Record<string, string>
```

### `JSON.parse()` boundaries

- Do not leave parsed JSON weakly typed deep in ArkTS code.
- Parse into an explicit interface when the payload shape is known.
- Use `Record<string, Object>` only as a temporary fallback for unknown shapes.
- Normalize external data into domain types early.

### `this` as a type

- Do not use `this` as a type annotation.
- Replace `this` with an explicit class or interface name.
- Introduce a shared interface when polymorphism is required.

Avoid:

```ts
class C {
  m(value: this) {}
}
```

Prefer:

```ts
class C {
  m(value: C) {}
}
```

### `bind`, `call`, and `apply`

- Do not treat runtime rebinding as a default ArkTS pattern.
- Prefer arrow functions for lexical `this`.
- Prefer explicit wrapper callbacks or explicit parameters over rebinding.

Avoid:

```ts
setTimeout(this.handleClick.bind(this), 300)
```

Prefer:

```ts
setTimeout(() => {
  this.handleClick()
}, 300)
```

### `globalThis`

- Do not use `globalThis` as a shared mutable store.
- Prefer module exports, singleton services, or explicit context objects.
- Keep ownership and lifecycle obvious.

### ArkTS and JS/TS boundaries

- Do not design code that requires JS/TS files to import ArkTS implementation files directly.
- Keep ArkUI and ArkTS-specific code on the ArkTS side.
- Move reusable pure logic into plain `.ts` modules when both sides need it.

Preferred split:

1. Put UI and ArkTS-specific implementation in `.ets`.
2. Put shared business logic in `.ts`.
3. Let ArkTS consume the shared layer instead of exposing `.ets` internals to JS/TS.

### `catch` variable typing

- Catch first, then cast inside the block if a specific error type is needed.
- Do not depend on TS-style typed `catch` parameters.

Prefer:

```ts
try {
  runTask()
} catch (error) {
  const businessError = error as BusinessError
  handleError(businessError)
}
```

### Constructor parameter properties

- Do not rely on TS constructor parameter-property shortcuts.
- Declare fields explicitly on the class, then assign them in the constructor.

Avoid:

```ts
class Person {
  constructor(private name: string) {}
}
```

Prefer:

```ts
class Person {
  private name: string

  constructor(name: string) {
    this.name = name
  }
}
```

### Regular expressions

- If the local ArkTS toolchain flags regex literals, replace them with `new RegExp(...)`.
- Keep the local compiler as the source of truth because this area has changed across SDK versions.

## Useful Rule Names

When a linter surfaces these names, use them as direct rewrite hints:

- `arkts-no-indexed-signatures`
- `arkts-no-typing-with-this`
- `arkts-no-func-bind`
- `arkts-no-globalthis`

## Review Checklist

- Map-like data uses `Record` or explicit models instead of weak dynamic objects.
- `JSON.parse()` results are typed and normalized early.
- `this` is not used as a type annotation.
- Callback code does not depend on `bind` as a default pattern.
- Shared state does not leak through `globalThis`.
- `.ets` and `.ts` boundaries are clean.
- Constructor fields are declared explicitly.
- Fixes follow current SDK/compiler behavior when it differs from older examples.
