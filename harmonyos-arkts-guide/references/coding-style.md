# ArkTS Coding Style Reference

Source:
- Huawei official guide: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-coding-style-guide

Use this file for baseline ArkTS style decisions. Apply project-local conventions first when they are already consistent and enforced.

## Naming

- Use meaningful, self-explanatory identifiers.
- Use `PascalCase` for classes, enums, namespaces, and type-like constructs.
- Use `camelCase` for variables, functions, methods, parameters, and object properties.
- Use `UPPER_SNAKE_CASE` for constants and constant-style enum values when that matches project style.
- Prefer positive boolean names such as `isReady`, `hasPermission`, `canRetry`, and `shouldUpdate`.
- Avoid vague abbreviations, single-letter names, and double negatives.

## Formatting

- Use spaces, not tabs.
- Default to 2-space indentation.
- Keep line length within 120 characters when practical.
- Always use braces for `if`, `else`, `for`, `while`, and similar control statements, even for a single statement.
- Put the opening brace at the end of the statement line.
- Put `else` and `catch` on the same line as the previous closing brace.
- Declare one variable per line.
- Break long expressions for readability instead of compressing them into one dense line.
- Expand object literals into multiple lines when they stop being easy to scan.
- Prefer single quotes unless the project formatter enforces another rule.

## Control Flow

- Prefer straightforward control flow over compact tricks.
- Avoid assignments inside conditional expressions.
- Prefer guard clauses when they reduce nesting.
- Keep `switch` indentation and `default` handling explicit.

Avoid:

```ts
if (value = getValue()) {
  handle(value)
}
```

Prefer:

```ts
const value = getValue()
if (value) {
  handle(value)
}
```

## Types and Syntax

- Prefer `T[]` over `Array<T>` unless a surrounding generic form makes `Array<T>` clearer.
- Write floating-point values as `0.5` or `2.0`, not `.5` or `2.`.
- Use `Number.isNaN(value)` for `NaN` checks.

## Safer Defaults

- Declare `private`, `protected`, or `public` on class members when the boundary matters.
- Avoid `return`, `break`, `continue`, or `throw` inside `finally` unless the behavior is fully intentional and reviewed.
- Prefer standard array methods such as `map`, `filter`, `reduce`, `find`, and `forEach` when they make the transformation clearer than a manual loop.
- Keep mutation visible and localized.

## Generation Defaults

When the repository does not already dictate style, generate ArkTS with these defaults:

- 2-space indentation
- single quotes
- explicit braces
- `camelCase` and `PascalCase`
- one declaration per line
- `T[]` for array types
- readable, explicit control flow

## Review Checklist

- Naming is descriptive and correctly cased.
- Indentation is consistent and uses spaces.
- Control statements always use braces.
- Declarations are not packed onto one line.
- `NaN` checks use `Number.isNaN()`.
- Conditions do not hide assignments.
- `finally` blocks do not override control flow accidentally.
- Types are as specific as practical.
