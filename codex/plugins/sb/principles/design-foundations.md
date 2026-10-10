# Practical Design Foundations

Use these ideas as tools for a concrete design question, not as a checklist or doctrine. Use it during investigation, planning, implementation, or review to resolve competing design criteria or a trusted-value, values/effects, or normal-flow question. Section links identify the owner of a related criterion when that question actually arises.

For each applicable question, identify the current evidence, the smallest useful move, and a counter-signal that would make the move harmful. When evidence is absent, preserve the existing design.

Good code shows the user's current task honestly with the fewest useful concepts and hides complex mechanics behind the place that can own them completely. Preserve necessary complexity that protects correctness. Keep other layers, abstractions, and extension points only when their current benefit justifies their implementation and maintenance cost.

## Judgment Priority

When principles pull in different directions, decide in this order:

1. Preserve correct user-observable behavior and data.
2. Make the normal use case and product policy visible.
3. Keep procedures and implementation knowledge out of callers that do not own them.
4. Give state, invariants, lifecycle, and error contracts one clear owner.
5. Require every added type, interface, layer, helper, and file to reduce a current concrete cost.
6. Prefer fewer names, branches, call hops, and concepts when the earlier priorities remain intact.

## 1. Start From the Use Case

**Question:** Where should the requested behavior be visible and coordinated?

Use [Composition and Mechanisms](composition-and-mechanisms.md) to place requirement policy and distinguish feature assembly from independent mechanics. Use [Intent and Contracts](intent-and-contracts.md) to keep the use-case vocabulary visible, and the normal-flow guidance below for its presentation.

## 2. Turn Raw Input Into Trusted Values

**Question:** Where does external data become safe for domain code, and how is that fact preserved?

- Parse external, persisted, IPC, and network data at the owning trust boundary into the most precise practical representation.
- Return a value that preserves what parsing proved instead of validating and discarding the result.
- Use product, sum, branded, refined, or abstract types when they exclude a meaningful illegal state or ambiguous domain value.
- Express remaining caller obligations, supplier guarantees, and stable object conditions as preconditions, postconditions, invariants, or assertions close to their owner.
- Let internal functions accept trusted values instead of repeating checks on raw primitives.
- Before adding a guard, nullable result, or exception protocol, ask whether the owning representation or operation can prevent that invalid state entirely. Preserve validation for untrusted inputs and handling for real external failures; do not redefine legitimate domain alternatives as errors.

**Counter-signals:** wrapper types that encode no invariant, repeated validation throughout the normal flow, boolean and nullable fields that permit contradictory states, or an elaborate type encoding whose cost exceeds the failure it prevents.

## 3. Separate Decisions From Effects at Real Seams

**Question:** Which code decides what should happen, and which code performs communication with the outside world?

- Keep domain decisions and transformations in a functional core when practical; let an imperative shell coordinate process, network, database, filesystem, clock, and UI effects.
- Use simple values at the seam so the core does not depend on transport or framework objects.
- Introduce a port for a purposeful external conversation when a production adapter and another justified adapter or test stand-in make the seam real.
- Keep technology conversion in adapters and application policy on the inside.

**Counter-signals:** business rules in UI or database wrappers, a port for every function, a Repository that only renames one database call, or dependency injection that exposes internal mechanics to ordinary callers.

## 4. Pull Complexity Down to Its Owner

**Question:** What must callers know, and who can own the relevant behavior completely?

Use [Deep Modules](deep-modules.md) for depth, locality, and seams; [Caller Obligations](caller-obligations.md) for actual interface use; and [Responsibility and Change](responsibility-and-change.md) for knowledge and dependency placement. For a shared-state/serialization decision, read [Separate Independent State](separate-shared-state.md).

## 5. Extract From Evidence

**Question:** What present benefit pays for an abstraction's build and carrying cost?

Make the current case usable before speculating about reusable capability. Account for implementation, delay, concepts, configuration, tests, call hops, maintenance, and eventual repair. YAGNI rejects presumptive future capability while allowing changes that simplify current behavior.

Use [Composition and Mechanisms](composition-and-mechanisms.md) for evidence of an independent obligation, [Deep Modules](deep-modules.md) for a useful interface/seam, and [Simplicity and Coupling](simplicity-and-coupling.md) for consolidation, separation, and independently changing concepts.

**Counter-signals:** justification based only on hypothetical future use, or flexibility that makes the accepted case harder to complete.

## 6. Keep the Normal Flow Visible

**Question:** Can a reader see the successful use case without first decoding defensive branches and infrastructure mechanics?

- Keep orchestration flat and intention-revealing.
- Use guard clauses for invalid inputs, failed preconditions, and exceptional states so they leave before the normal path.
- Hide necessary low-level mechanics behind the narrowest owning interface rather than fragmenting an obvious operation into shallow helpers.
- Let errors reach the existing user-facing boundary unless recovery is an explicit requirement.

**Counter-signals:** guards that obscure normal domain alternatives, helpers that only rename adjacent lines, or failure machinery added without a reachable case or runtime evidence.

## 7. Test Stable Responsibilities

**Question:** Which responsibility owns the guarantee and what evidence distinguishes correct behavior?

Use [Behavioral Verification](behavioral-verification.md) for observation targets, test placement, regression proof, and valid fixtures. It owns those detailed criteria.

## Resolve the Apparent Tensions

- **Vertical slices and deep modules:** compose the use case vertically; deepen only mechanisms whose ownership and obligations are independently real.
- **Transaction Script and richer domain structure:** begin with the direct request flow; move logic when stable invariants or repeated domain behavior reveal an owner.
- **Ports and YAGNI:** isolate a real external conversation, not every dependency. Do not add an interface solely to support a hypothetical variation.
- **Types and contracts:** use types for constructible states and value precision; use assertions for obligations and guarantees the type system cannot express economically.
- **Locality and separation:** colocate knowledge that changes together while keeping domain decisions separate from infrastructure effects.
- **YAGNI and strategic design:** avoid future capability while continuing to simplify interfaces and keep present code easy to change.

## Apply the Principles to a Task

- Start from the accepted use case, actual or explicitly proposed callers, data flow, and preserved behavior. Use only principles supported by that evidence; do not fill a checklist.
- Name the observed burden before the design term. Say what callers repeat, what invariant can break, or where change propagates before calling a module shallow or a responsibility misplaced.
- For each suggestion, identify the current user goal, the unnecessary knowledge or risk, the smallest before/after shape, and the counterevidence that would withdraw the suggestion.
- Address one root cause once. Several principles may explain it without requiring separate changes or findings.

## Source Vocabulary

- John Ousterhout, [A Philosophy of Software Design](https://web.stanford.edu/~ouster/cgi-bin/book.php) and [Managing Complexity](https://web.stanford.edu/~ouster/cgi-bin/cs190-spring15/lecture.php?topic=complexity)
- Gary Bernhardt, [Boundaries](https://www.destroyallsoftware.com/talks/boundaries)
- Scott Wlaschin, [Making Illegal States Unrepresentable](https://fsharpforfunandprofit.com/posts/designing-with-types-making-illegal-states-unrepresentable/)
- Alexis King, [Parse, Don't Validate](https://lexi-lambda.github.io/blog/2019/11/05/parse-don-t-validate/)
- Eiffel, [Design by Contract and Assertions](https://www.eiffel.org/doc/eiffel/I2E-_Design_by_Contract_and_Assertions)
- Martin Fowler, [Replace Nested Conditional with Guard Clauses](https://refactoring.com/catalog/replaceNestedConditionalWithGuardClauses.html), [YAGNI](https://martinfowler.com/bliki/Yagni.html), [Transaction Script](https://martinfowler.com/eaaCatalog/transactionScript.html), and [Tell, Don't Ask](https://martinfowler.com/bliki/TellDontAsk.html)
- Casey Muratori, [Semantic Compression](https://caseymuratori.com/blog_0015)
- Alistair Cockburn, [Hexagonal Architecture](https://alistair.cockburn.us/hexagonal-architecture)
- Jimmy Bogard, [Vertical Slice Architecture](https://www.jimmybogard.com/vertical-slice-architecture/)
- Robert C. Martin, [Screaming Architecture](https://blog.cleancoder.com/uncle-bob/2011/09/30/Screaming-Architecture.html)
- Carson Gross, [Locality of Behaviour](https://htmx.org/essays/locality-of-behaviour/)
- [The Grug Brained Developer](https://grugbrain.dev/)
