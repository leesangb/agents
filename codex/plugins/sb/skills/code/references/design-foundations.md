# Practical Design Foundations

Use these ideas as tools for a concrete design question, not as a checklist or doctrine. Read this reference only when a plan or architecture review must decide use-case structure, value or effect boundaries, module depth, ownership, or abstraction timing.

For each applicable question, identify the current evidence, the smallest useful move, and a counter-signal that would make the move harmful. When evidence is absent, preserve the existing design.

## 1. Start From the Use Case

**Question:** Where should the requested behavior be visible and coordinated?

- Start with the smallest honest procedure or vertical slice that completes one request.
- Let the top-level structure and vocabulary reveal the domain capability or user behavior rather than its framework.
- Keep requirement-owned ordering, branching, failure policy, and lifecycle at the highest requirement-specific composition point.
- Let each use case adopt only the structure it needs; do not require every request to cross the same Controller, Service, and Repository layers.

**Counter-signals:** a shared abstraction before a second concrete use, framework vocabulary hiding the use case, or a transaction split across files that add call hops without hiding knowledge.

## 2. Turn Raw Input Into Trusted Values

**Question:** Where does external data become safe for domain code, and how is that fact preserved?

- Parse external, persisted, IPC, and network data at the owning trust boundary into the most precise practical representation.
- Return a value that preserves what parsing proved instead of validating and discarding the result.
- Use product, sum, branded, refined, or abstract types when they exclude a meaningful illegal state or ambiguous domain value.
- Express remaining caller obligations, supplier guarantees, and stable object conditions as preconditions, postconditions, invariants, or assertions close to their owner.
- Let internal functions accept trusted values instead of repeating checks on raw primitives.

**Counter-signals:** wrapper types that encode no invariant, repeated validation throughout the normal flow, boolean and nullable fields that permit contradictory states, or an elaborate type encoding whose cost exceeds the failure it prevents.

## 3. Separate Decisions From Effects at Real Seams

**Question:** Which code decides what should happen, and which code performs communication with the outside world?

- Keep domain decisions and transformations in a functional core when practical; let an imperative shell coordinate process, network, database, filesystem, clock, and UI effects.
- Use simple values at the seam so the core does not depend on transport or framework objects.
- Introduce a port for a purposeful external conversation when a production adapter and another justified adapter or test stand-in make the seam real.
- Keep technology conversion in adapters and application policy on the inside.

**Counter-signals:** business rules in UI or database wrappers, a port for every function, a Repository that only renames one database call, or dependency injection that exposes internal mechanics to ordinary callers.

## 4. Pull Complexity Down to Its Owner

**Question:** What must callers know, and which module owns the relevant state, invariant, lifecycle, or mechanism?

- Prefer a deep module: substantial useful behavior behind a small interface that includes all caller-visible obligations.
- Push parsing mechanics, protocol details, ordering, cleanup, and state surgery into the lowest module that can own them completely.
- Keep behavior with the state and invariants it changes; tell the owner the domain operation instead of reading its state and mutating it elsewhere.
- Optimize for locality: a maintainer should find the behavior, knowledge, and verification in the smallest reasonable area.
- Judge depth by caller leverage and hidden knowledge, not implementation size.

**Counter-signals:** pass-through interfaces, similar call names repeated down a deep stack, helper shrapnel, callers reconstructing one operation, getter eradication that makes collaboration less clear, or a large module that merely mixes unrelated change axes.

## 5. Extract From Evidence

**Question:** What present evidence makes an abstraction or capability worth its build and carrying cost?

- Make the first case usable before making it reusable.
- Start directly, then extract after real examples reveal stable shared semantics or an independent invariant, lifecycle, error contract, performance contract, or test surface.
- Treat speculative capabilities and flexibility as costs: implementation, delay, concepts, configuration, tests, call hops, maintenance, and eventual repair.
- Refactor to keep the code malleable; YAGNI rejects presumptive capability, not improvements that simplify current behavior.
- Preserve duplication when the apparent similarity represents different reasons to change.

**Counter-signals:** justification based only on "could", "might", or "later"; option bags for imagined callers; a pattern name used as the reason for a layer; or an abstraction that makes current requirements harder to understand.

## 6. Keep the Normal Flow Visible

**Question:** Can a reader see the successful use case without first decoding defensive branches and infrastructure mechanics?

- Keep orchestration flat and intention-revealing.
- Use guard clauses for invalid inputs, failed preconditions, and exceptional states so they leave before the normal path.
- Hide necessary low-level mechanics behind the narrowest owning interface rather than fragmenting an obvious operation into shallow helpers.
- Let errors reach the existing user-facing boundary unless recovery is an explicit requirement.

**Counter-signals:** guards that obscure normal domain alternatives, helpers that only rename adjacent lines, or failure machinery added without a reachable case or runtime evidence.

## Resolve the Apparent Tensions

- **Vertical slices and deep modules:** compose the use case vertically; deepen only mechanisms whose ownership and obligations are independently real.
- **Transaction Script and richer domain structure:** begin with the direct request flow; move logic when stable invariants or repeated domain behavior reveal an owner.
- **Ports and YAGNI:** isolate a real external conversation, not every dependency; a hypothetical variation does not earn a seam.
- **Types and contracts:** use types for constructible states and value precision; use assertions for obligations and guarantees the type system cannot express economically.
- **Locality and separation:** colocate knowledge that changes together while keeping domain decisions separate from infrastructure effects.
- **YAGNI and strategic design:** avoid future capability while continuing to simplify interfaces and keep present code easy to change.

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
