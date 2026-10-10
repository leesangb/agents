# Re-execution Safety

Use for commands, migrations, lifecycle steps, or processing loops whose contract permits retrying or resuming after partial failure. Different intended user operations need not converge to the same state.

## Trace the Same Logical Operation

- What happens if the same logical operation runs twice with the same relevant input?
- What durable state or external effect remains if execution stops at a reachable side-effect boundary?
- Does retrying from that state complete the accepted operation without duplicating its effects, losing data, or adopting someone else's resources?

Follow the operation's identity, completion record, persisted state, and external effects through those cases. An uncertain external response does not prove that nothing happened. Check the owning system's actual guarantees before recommending a retry, deduplication key, transaction, or reconciliation step. Prefer an existing mechanism; do not promise exactly-once execution or add locks merely because a retry is possible.

## Obtain Proportionate Evidence

Compare the completed outcome and relevant side effects of an initial run, a repeated run, and the material partial-failure states. Use existing tests or a disposable fixture where practical. Choose boundaries supported by the failure model rather than attempting to crash at every instruction. Keep checks within authorized environments and effects; unavailable failure injection stays unverified.

Recovery and cleanup must distinguish owned disposable state from existing or unrelated data. Preserve required compatibility and legitimate non-idempotent behavior. Report the reachable failure, the supported guarantee, the smallest correction when needed, and exact observed evidence or remaining uncertainty.
