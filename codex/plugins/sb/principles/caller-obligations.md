# Caller Obligations

Use when designing or changing a callable interface, module API, component/hook contract, command, event, or schema that a caller must understand.

Identify the actual interface and representative callers for every materially distinct use. For new behavior, start from the accepted use case and a proposed call site, labeled as proposed. Enumerate external facades, internal collaboration interfaces, and hook/component wiring contracts as distinct surfaces when their caller patterns differ. Expand discovery when the contract is broad or a consequence remains unresolved.

## Express the Common Use Case

State the caller's goal in one sentence, then compare the actual or proposed call with the smallest honest interface for that normal use case. Account for setup, ordering, cleanup, internal IDs, callbacks, options, conversions, lifecycle, and errors. Rare exceptions or extension points should justify the obligations they add to that normal path.

For each distinct caller pattern, separate the caller's goal and product/domain policy from mechanics the module can own completely. A compact comparison can help: `caller goal | caller-owned policy | module-owned mechanics | leaked implementation knowledge | builtin alternative`. Group equivalent calls. Fewer parameters are useful only when the removed choice is not a legitimate caller decision.

For an injected callback, configuration value, or wrapper, trace where the caller gets it and whether the caller uses it independently of forwarding it. Different implementations alone do not establish caller ownership. Distinguish dynamic product policy from stable context that fully determines the mechanics; compare the latter with a context-specific call or an honest discriminated input.

Check whether the signature makes the happy path and next action clear. Optional parameters that select distinct workflows may be clearer as separate operations or explicit variants. Give callbacks the capabilities they need: cancellation-aware work may need only an `AbortSignal`, rather than the full task controller. Prove a proposed shape through representative call sites, updating them alongside an authorized API change.

## Hide Mechanics, Preserve Contracts

- Check whether the interface reflects the accepted use cases or merely the implementation/first caller.
- Compare custom managers, adapters, or classes with language/runtime primitives using [Prefer Builtin Contracts](#prefer-builtin-contracts).
- For caller-visible async values, errors, fallbacks, or lifecycle, follow a representative value through its first stateful cache, state, or render consumer. When recovery matters, follow failure → fallback → recovery.
- Trace a proposed primitive or extension point's obligations through every materially distinct caller pattern.

Explain observed caller burden before design terminology; compare a representative before/after call when useful.

## Prefer Builtin Contracts

Identify the underlying concept before accepting a custom protocol. Compare async sequences with `AsyncIterable`, synchronous sequences with `Iterable` or arrays, cancellation with `AbortSignal`, completion with `Promise`, keyed lookup with `Map`, and one-step work with a function. Plain objects can represent data without a lifecycle wrapper. Keep project-specific behavior behind the builtin boundary when the builtin preserves the required contract.

For streams, check whether callers really need readers, locks, controllers, and release protocols or only iteration over arriving values. Preserve material backpressure, ownership, error, and cleanup guarantees when comparing alternatives. A richer lifecycle object can be justified when callers actually control more than cancellation or completion.

A custom abstraction earns its boundary when it protects an invariant, removes repeated ceremony, or expresses a real domain distinction the builtin cannot represent. Similar type shapes alone do not prove equivalence. Preserve legitimate caller choices and independently meaningful outcomes; use [Intent and Contracts](intent-and-contracts.md) when their representation or meaning is unclear.

## Related Questions

- If caller evidence leaves a question about interface depth or the value of hiding mechanics, use [Deep Modules](deep-modules.md).
- If correcting the interface requires deciding whether a new mechanism/extension contract should exist, use [Composition and Mechanisms](composition-and-mechanisms.md).
