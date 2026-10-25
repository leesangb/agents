---
name: typescript-best-practices
description: "Apply TypeScript coding guidance when reading, writing, or reviewing .ts and .tsx files: precise domain types, boundary validation, narrowing, value-oriented code, and inferred returns."
---

# TypeScript Best Practices

Write TypeScript that states the intended result directly and preserves compiler-checkable evidence. Follow the repository's supported compiler, configuration, and established conventions. This skill replaces the personal `ts-coding-guideline.md`; it combines that guide with pstack's TypeScript guidance.

## Prefer Values and Builtins

Prefer inference and control-flow narrowing, then `const` values and value-producing branches, then builtins that express the transformation. Use `satisfies`, truthful guards, and discriminated unions to preserve relationships. Local mutation or an assertion can be appropriate when the alternatives are less correct or materially less clear.

- Use `const` unless reassignment expresses necessary behavior. Replace placeholders assigned from several branches with early returns or branches that produce a value.
- Prefer pure transformations with explicit inputs and returned results. Construct new arrays and objects when the immutable expression stays clear; name intermediate values when a chain becomes hard to read.
- Use `map`, `filter`, `find`, `some`, `every`, and `flatMap` for their actual array operations; `Set` for uniqueness/membership; `Map` for keyed lookup; `Object.entries`, `Object.fromEntries`, and spread for object transformations; and `Array.from` for iterables or known lengths.
- Use optional chaining and nullish coalescing for absent values, preserving distinctions such as empty strings, zero, and false. Use `Promise.all` for independent concurrent work when its failure and resource behavior fit.
- Keep a clear loop rather than hiding it in a clever `reduce`; use iteration for effects. Keep mutation local when state change is the behavior, a loop is clearer, or measurement justifies it. A helper that only renames a builtin adds no useful boundary.

## Model the Domain Precisely

Use the trusted-value criteria in [Practical Design Foundations](../principle-design-foundations/SKILL.md#2-turn-raw-input-into-trusted-values) when choosing a representation or validation owner, and [Intent and Contracts](../principle-intent-and-contracts/SKILL.md) when deciding which distinctions callers need. These existing principles own the language-independent rules.

- Model mutually exclusive variants as a discriminated union instead of boolean flags and optional fields that allow contradictions. Preserve a consistent discriminant name in the surrounding code.
- Brand primitives when interchangeable values would permit a real domain mistake, such as mixing two kinds of IDs. Reuse the project's brand convention; otherwise a readonly brand intersection is sufficient. Validate at construction and preserve the distinction downstream.
- Choose a representation that excludes the actual bad state: `[T, ...T[]]` guarantees a first element and `[T, T][]` represents pairs. Keep ordinary arrays when empty input is valid and every operation handles it; returning `T | undefined` is also an honest contract. Strengthen inputs where a real precondition otherwise forces `!`, a cast, or a spurious impossible-state exception.
- Check what a representation really proves. A tuple does not prove an arbitrary numeric index is in bounds. `start` plus `durationMs: number` does not exclude negative, infinite, or NaN durations; validate such constraints at the owning boundary when required.
- Derive from authoritative generated types or existing schemas rather than duplicating their shapes. Prefer `Pick`, `Omit`, `Extract`, `Exclude`, `NonNullable`, `Parameters`, `ReturnType`, `Awaited`, and `typeof` when they express that relationship; a new named domain type still needs its own meaning.

## Parse at the Boundary, Preserve the Evidence

- Treat untrusted JSON, RPC/IPC messages, configuration, environment variables, file contents, and unvalidated storage results as `unknown`. Parse them into the domain model at their owning trust boundary. A broad `Record<string, unknown>` is a parse input, not the internal domain model.
- Reuse the repository's runtime schema library and existing schemas before writing property-by-property guards. Infer the type from its schema, or check a schema against an independently owned domain type. Do not add a schema dependency for one small guard.
- Trust facts the parser actually established; preserve real external failures, mutable-state invariants, and supported domain alternatives. Internal typing is not a reason to discard runtime error handling. [Correctness and Failure Paths](../principle-correctness-and-failure-paths/SKILL.md) owns recovery and error propagation.
- Prefer discriminant narrowing, then `in`, `typeof`/`instanceof`, and a truthful `isX`/`hasX` predicate when built-in narrowing is insufficient. A predicate or assertion function must check the complete claim it makes; a brand predicate must verify its actual domain constraint.
- Use `satisfies` to check compatibility while preserving useful inference. It checks static compatibility; it does not parse or convert `unknown` at runtime.
- Treat `as any`, `as never`, and `as unknown as T` as explicit escape hatches. A single `as T` belongs only at the narrowest boundary where a known invariant cannot be expressed economically; explain non-obvious evidence. Replacing a cast with a lying predicate does not make it safer.
- Never force a value `as never` to silence a call-site or exhaustiveness error, or write a predicate/assertion function that merely claims success without checking its input.
- Use `as const` for literal/readonly preservation, not to force unrelated compatibility. Let narrowing establish `never` for an exhaustive check; do not cast to silence missing variants.

## Infer Returns, Preserve Branchable Results

- Infer return types by default for local and internal functions. Add an explicit return type when it defines a deliberate public contract, breaks recursive inference, or protects an exported API from accidental change.
- Preserve meaningful result states as literals or discriminated unions. Keep ordinary absence or presentation strings when that is their entire meaning; do not invent variants for labels.
- Use `satisfies` on returned variants when a named domain type should be checked without replacing the inferred return type with a broad annotation.
- Check exhaustiveness with a `never` assignment or the project's existing throwing `assertNever` helper. Preserve useful runtime failure behavior if unexpected external values can still arrive.

## Caller Interfaces, Tests, and Diagnostics

Prefer an object parameter when several arguments are easy to swap or their grouping expresses a real domain relationship. Keep simple positional calls and existing contracts when they are clearer. Follow [Caller Obligations](../principle-caller-obligations/SKILL.md) before changing an API; allocation claims on hot paths need measurement.

Use [Behavioral Verification](../principle-behavioral-verification/SKILL.md) for test boundaries and realistic evidence, plus applicable local test instructions. Prefer real deterministic collaborators; use fakes or mocks at justified external boundaries. Run UI verification when the changed behavior requires it, not merely because a file is TypeScript.

Use the application's existing structured logger and useful operation/target context for shipped diagnostics. Preserve intentional CLI/stdout contracts and supported browser diagnostics; a blanket ban on `console` is not a substitute for understanding the output owner.

Read [Patterns](references/patterns.md) when a concrete example of inferred result unions, brands, total collection operations, or exhaustive checking would help. Run the repository's relevant typecheck and behavior checks; do not change compiler configuration or refactor unrelated code just to apply this skill.
