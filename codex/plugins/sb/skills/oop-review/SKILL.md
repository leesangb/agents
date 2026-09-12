---
name: oop-review
description: Review TypeScript object-oriented design for behavioral contracts, substitutability, encapsulation, inheritance and implementation relationships, domain invariants, API design, and type safety. Use when reviewing changes to inheritance, interfaces, abstract classes, implementations, extension points, mutable domain state, or other OOP contracts.
---

# OOP Review

Review only the supplied scope for semantic object-oriented design problems. Do not edit files, post comments, or spawn more work.

Prioritize, in order:

1. correctness and behavioral contracts;
2. domain invariants;
3. encapsulation;
4. responsibility and coupling;
5. type safety;
6. safe evolution.

Ignore formatting, naming preferences, import order, semicolons, quote style, and lint findings unless they directly affect an OOP contract.

## Establish the review scope

- Keep the caller's scope, assumptions, and behavior-preservation constraints authoritative.
- Read full changed files, direct callers, implementations, subclasses, interfaces, extension points, mutable state, invariants, and relevant tests.
- Do not infer a behavioral contract from a type signature alone. Use documentation, call sites, tests, sibling implementations, and observable behavior as evidence.
- Identify missing evidence instead of presenting an unsupported suspicion as a defect.
- Do not widen into general correctness, naming, architecture, API, or test review unless the issue is specifically an OOP contract.

## Apply review discipline

- Report only concrete, actionable problems backed by a reachable trigger or observable consequence.
- Do not invent findings to cover every category.
- Distinguish design defects from reasonable trade-offs and personal preferences.
- Report one root cause once, with other locations as supporting evidence.
- Explain why the current design is unsafe before recommending a change.
- Recommend the smallest safe design-level correction that addresses the cause.
- Avoid speculative frameworks, abstractions, and extensibility with no demonstrated need.
- Do not prescribe one implementation when several corrections satisfy the contract.
- Keep `Suggestion` findings non-blocking and separate from concrete design blockers. Never start a fix loop for suggestions alone.

## Review contracts and substitutability

For inheritance, interfaces, abstract classes, implementations, and overrides, verify behavioral compatibility rather than signature compatibility alone.

Check whether:

- an implementation strengthens preconditions;
- an implementation weakens postconditions;
- parent or domain invariants can be broken;
- return values preserve their documented meaning;
- error behavior or exception semantics change;
- ordering guarantees change;
- synchronous behavior becomes asynchronous or deferred;
- logging, persistence, network access, events, analytics, or cache mutation surprise callers;
- a subtype can safely replace its parent in every supported use.

Treat abstract classes and interfaces as semantic contracts. Matching method signatures do not prove that an implementation satisfies the abstraction.

## Review encapsulation and extension surfaces

Check whether:

- mutable internal state is exposed;
- external code or subclasses can bypass invariants;
- public members represent intentional compatibility promises;
- protected members form safe, intentional extension points;
- a protected hook would preserve invariants better than protected mutable state;
- parameters, return types, errors, or lifecycle requirements leak implementation details.

Apply this model:

- `private` protects invariants;
- `protected` defines an inheritance API;
- `public` creates a compatibility commitment.

Do not recommend broader visibility merely to simplify tests or reuse implementation.

## Review abstraction, inheritance, and responsibility

Check whether:

- inheritance represents a genuine behavioral is-a relationship;
- a subclass exists only to reuse implementation;
- composition would model variation more safely;
- types represent domain concepts rather than storage, framework, or vendor details;
- a class or method owns unrelated reasons to change;
- orchestration, business rules, and infrastructure concerns are mixed in a way that weakens an OOP contract;
- an abstraction hides complexity or merely adds indirection;
- an API is more concrete or extensible than current requirements justify.

Do not reject inheritance categorically. Reject it when substitution is false, invariants are fragile, or reuse is the only relationship.

## Review domain and type integrity

Check whether:

- invalid domain states are representable without a clear reason;
- construction and mutation boundaries enforce business invariants;
- mutation is controlled and visible;
- ambiguous primitives represent distinct domain concepts;
- optional properties model actual optionality rather than incomplete construction;
- `any`, unsafe casts, or non-null assertions bypass meaningful constraints;
- discriminated unions, branded types, literal types, generics, `readonly`, or `satisfies` would materially improve correctness.

Recommend stronger types only when they encode a real invariant or remove an unsafe state. Do not turn every primitive into a wrapper or every object into a class.

## Review safe evolution

Check whether a plausible change axis is constrained by:

- leaked implementation details;
- overly concrete public types;
- tight coupling to infrastructure or vendors;
- inheritance lock-in;
- unnecessary public or protected surface;
- hidden ordering, lifecycle, or side-effect requirements.

Require evidence for the change axis from requirements, nearby implementations, tests, or existing variation. Do not report hypothetical extensibility concerns.

## Assign severity

- **Critical:** Breaks correctness, behavioral contracts, or invariants, or creates likely data or security damage.
- **Major:** Creates unsafe substitution, invalid domain states, substantial coupling, or a likely breaking evolution path.
- **Minor:** Creates a localized design weakness with limited current impact and a concrete maintenance cost.
- **Suggestion:** Offers an optional improvement with a clear benefit; it is not a defect or approval blocker.

Do not assign blocker severity without a reachable trigger or observable consequence, and do not inflate severity based on hypothetical future misuse.

## Return finding drafts

Order findings by provisional severity. Include precise location, the relevant OOP principle and contract evidence, a reachable trigger, consequence, smallest safe design correction, and focused verification. Use the most precise relevant line and cite other locations as supporting evidence. Separate non-blocking suggestions from design blockers. Choose the format that makes the contract and consequence clear; a fixed template is not required.

If no concrete defects remain, return a concise evidence-backed no-findings result for the selected scope. Omit placeholder suggestions and style-review sections.

## Verify the review

Before returning, confirm:

- every finding has code and contract evidence;
- behavioral claims use more than a signature when evidence is available;
- every blocker has a reachable trigger or observable consequence;
- no root cause is reported twice;
- severity matches the stated consequence;
- recommendations address causes rather than cosmetic symptoms;
- style, unsupported future-proofing, and out-of-scope findings are removed;
- the entire supplied scope is accounted for, including an explicit no-findings result.
